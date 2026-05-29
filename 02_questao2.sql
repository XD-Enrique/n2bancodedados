-- QUESTÃO 2: Listar o nome das escolas e a quantidade de alunos,
-- ordenando da que tem mais alunos para a que tem menos.

SELECT 
    e.nome AS escola, 
    COUNT(m.aluno_id) AS total_alunos
FROM escolas e
LEFT JOIN matriculas m ON e.id = m.escola_id
GROUP BY e.id, e.nome
ORDER BY total_alunos DESC;