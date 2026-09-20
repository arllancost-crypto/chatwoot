"""Local adversarial regression tests; use only synthetic marker strings."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

SCANNER = Path(__file__).with_name('yara_quality_gate.sh').resolve()


class PolicyTests(unittest.TestCase):
    def evaluate(self, filename, content, *, invalid_base=False):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            def git(*args):
                return subprocess.check_output(['git', *args], cwd=root, stderr=subprocess.DEVNULL).decode().strip()
            git('init', '-q')
            git('config', 'user.name', 'Policy Test')
            git('config', 'user.email', 'policy@example.invalid')
            git('commit', '--allow-empty', '-qm', 'base')
            base = git('rev-parse', 'HEAD')
            path = root / filename
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content)
            git('add', '.')
            git('commit', '-qm', 'candidate')
            result = subprocess.run(['bash', str(SCANNER)], cwd=root,
                env={**os.environ, 'BASE_SHA': 'invalid' if invalid_base else base,
                     'HEAD_SHA': git('rev-parse', 'HEAD')}, capture_output=True, text=True)
            return result

    def test_normal_change(self):
        self.assertEqual(self.evaluate('example.txt', 'ordinary content').returncode, 0)

    def test_sensitive_filename(self):
        self.assertNotEqual(self.evaluate('.env', 'synthetic').returncode, 0)

    def test_fixture_and_scanner_not_exempt(self):
        for name in ('spec/fixtures/example.txt', 'test/fixtures/example.txt', 'script/yara_quality_gate.sh'):
            with self.subTest(name=name):
                result = self.evaluate(name, 'DATABASE_' + 'URL=synthetic-marker-never-real')
                self.assertNotEqual(result.returncode, 0)
                self.assertNotIn('synthetic-marker-never-real', result.stdout + result.stderr)

    def test_script_replacement_does_not_execute(self):
        result = self.evaluate('script/yara_quality_gate.sh', 'exit 0\n' + 'YARA_' + 'DATABASE_URL')
        self.assertNotEqual(result.returncode, 0)

    def test_invalid_revision_fails(self):
        self.assertNotEqual(self.evaluate('example.txt', 'ordinary', invalid_base=True).returncode, 0)


if __name__ == '__main__':
    unittest.main()
