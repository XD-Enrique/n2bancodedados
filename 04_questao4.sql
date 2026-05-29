-- QUESTÃO 4: Retornar o nome do aluno, alternativa escolhida e 
-- se acertou, filtrando pela questão 45 e pelo CNPJ da escola.

SELECT 
    p.nome_completo AS aluno, 
    r.alternativa_escolhida, 
    r.acertou
FROM respostas r
JOIN sessoes_simulado s ON r.sessao_id = s.id
JOIN perfis p ON s.aluno_id = p.id
JOIN matriculas m ON p.id = m.aluno_id
JOIN escolas e ON m.escola_id = e.id
JOIN questoes q ON r.questao_id = q.id
WHERE q.numero_identificacao = 45 
  AND e.cnpj = '12.345.678/0001-99';