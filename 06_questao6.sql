-- QUESTÃO 6: Identificar sessões onde os totais armazenados
-- divergem da contagem real de respostas na base de dados.


SELECT 
    s.id AS sessao_id,
    s.total_questoes AS total_questions_armazenado,
    COUNT(r.id) AS contagem_real_respostas,
    s.total_acertos AS correct_count_armazenado,
    COALESCE(SUM(CASE WHEN r.acertou THEN 1 ELSE 0 END), 0) AS contagem_real_acertos
FROM sessoes_simulado s
LEFT JOIN respostas r ON s.id = r.sessao_id
WHERE s.estado = 'concluida'
GROUP BY s.id, s.total_questoes, s.total_acertos
HAVING s.total_questoes <> COUNT(r.id) 
    OR s.total_acertos <> COALESCE(SUM(CASE WHEN r.acertou THEN 1 ELSE 0 END), 0);