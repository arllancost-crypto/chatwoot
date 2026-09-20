# Desenvolvimento do YARA Atendimento

Base para Davi: `yara/dev-4.16.2`, derivada de
`70e284a044f00326725f65f703162745371075ec`, mesma revisão oficial da imagem
`chatwoot/chatwoot:v4.16.2-ce` instalada na 13000. develop (4.18) foi preservada.
Diferenças desta base: governança, workflows e documentação; não código de negócio.

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

Base alinhada; setup local e build completo ainda precisam ser validados.
Workflow confiável também precisa aceitar esta branch na definição da branch
padrão do GitHub. A regra obrigatória deve permanecer bloqueante enquanto essa
ativação não estiver comprovada. Não interpretar checks ausentes como aprovação.
