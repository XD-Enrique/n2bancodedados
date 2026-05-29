-- QUESTÃO 7: Listar os 5 alunos com maior número de acertos, 
-- considerando apenas quem respondeu a 100 questões ou mais.

SELECT 
    p.nome_completo AS aluno, 
    SUM(s.total_acertos) AS total_acertos_acumulados
FROM perfis p
JOIN sessoes_simulado s ON p.id = s.aluno_id
WHERE s.estado = 'concluida'
GROUP BY p.id, p.nome_completo
HAVING SUM(s.total_questoes) >= 100
ORDER BY total_acertos_acumulados DESC
LIMIT 5;