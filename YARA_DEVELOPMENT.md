# Desenvolvimento do YARA Atendimento

Base para Davi: `yara/dev-4.16.2`, derivada de
`70e284a044f00326725f65f703162745371075ec`, mesma revisão oficial da imagem
`chatwoot/chatwoot:v4.16.2-ce` instalada na 13000. develop (4.18) foi preservada.
Essa é a origem histórica, não uma promessa de identidade com o servidor:
a preparação inclui correções de segurança, Rails 8.1 e ajustes de compatibilidade.
Consulte `SECURITY_REVIEW.md` e os arquivos `YARA_PATCH.md` das bibliotecas locais.

## Fluxo

Faça fork de arllancost-crypto/chatwoot e crie sua branch a partir de
yara/dev-4.16.2, nunca da branch adversarial yara/validate-trusted-policy.
Abra PR com base yara/dev-4.16.2. Testes obrigatórios e integração exclusiva
do proprietário; publicação no servidor requer autorização e backup.
Não há deploy automático. Não copiar .env, bancos ou tokens do servidor.

## Instalação existente

13000 é desenvolvimento/validação com conversas de teste. Core e IXC são reais;
ações de atendimento podem afetar clientes. Usar VPN e usuário individual.
Branding e configuração de integração do servidor não fazem parte da imagem
oficial: a equivalência da fonte não reproduz sozinha o ambiente completo.
O 360 possui ponte própria no Core, não código contido neste repositório.

## Estado da entrega

A política confiável já aceita esta branch a partir da definição aprovada na
branch padrão. Correções de compatibilidade estão sendo validadas no PR #5;
não usar a branch como entrega final antes da aprovação de todos os checks
obrigatórios e da integração pelo proprietário. Checks ausentes não são aprovação.

## Para Davi começar depois da integração

1. Entre no GitHub como `davirodrigues-eng` e faça fork deste repositório.
2. Clone seu fork e busque a branch `yara/dev-4.16.2` do repositório original.
3. Crie uma branch de trabalho a partir dessa base, uma por alteração.
4. Prepare banco e Redis locais, usando apenas dados fictícios e configuração
   de desenvolvimento; nunca copie credenciais, banco ou arquivos privados do servidor.
5. Faça os testes locais, envie os commits ao seu fork e abra um PR apontando
   para `arllancost-crypto/chatwoot`, base `yara/dev-4.16.2`.
6. O Quality roda no PR. Arllan decide a integração; o desenvolvedor não publica
   diretamente no servidor. Cada publicação precisa de autorização e possibilidade de retorno.

O acesso ao aplicativo 13000 pela VPN é separado do acesso GitHub. A aplicação
local não recebe automaticamente a integração Customer 360: ela depende da
ponte e das permissões do Core. Validar essa integração requer ambiente e conta
autorizados, sem colocar tokens do Core/IXC no navegador ou no repositório.
