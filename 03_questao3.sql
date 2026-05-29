-- QUESTÃO 3: Listar o nome completo e o ID de todos os 
-- alunos que nunca iniciaram uma sessão de simulado.

SELECT 
    id, 
    nome_completo
FROM perfis
WHERE papel = 'aluno' 
  AND id NOT IN (SELECT aluno_id FROM sessoes_simulado);