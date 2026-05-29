-- QUESTÃO 5: Calcular a taxa média de acerto (percentual) 
-- global por escola, baseando-se nas sessões concluídas.

SELECT 
    e.nome AS escola, 
    ROUND((SUM(s.total_acertos)::NUMERIC / NULLIF(SUM(s.total_questoes), 0)) * 100, 2) AS percentual_acerto
FROM escolas e
JOIN matriculas m ON e.id = m.escola_id
JOIN sessoes_simulado s ON m.aluno_id = s.aluno_id
WHERE s.estado = 'concluida'
GROUP BY e.id, e.nome
ORDER BY percentual_acerto DESC;