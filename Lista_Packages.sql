-- Ativar saída de dados
SET SERVEROUTPUT ON;

-- ================================
-- Pacote PKG_ALUNO
-- ================================

CREATE OR REPLACE PACKAGE PKG_ALUNO AS
    -- Procedure de exclusão de aluno
    PROCEDURE ExcluirAluno(p_aluno_id IN NUMBER);

    -- Cursor de listagem de alunos maiores de 18 anos
    PROCEDURE ListarAlunosMaioresDe18;

    -- Cursor com filtro por curso
    PROCEDURE ListarAlunosPorCurso(p_id_curso IN NUMBER);
END PKG_ALUNO;
/
CREATE OR REPLACE PACKAGE BODY PKG_ALUNO AS
    -- Procedure de exclusão de aluno
    PROCEDURE ExcluirAluno(p_aluno_id IN NUMBER) IS
    BEGIN
        DELETE FROM matriculas WHERE id_aluno = p_aluno_id;
        DELETE FROM alunos WHERE id = p_aluno_id;
        COMMIT;
    END;

    -- Cursor de listagem de alunos maiores de 18 anos
    PROCEDURE ListarAlunosMaioresDe18 IS
        CURSOR alunos_cursor IS
            SELECT nome, data_nascimento
            FROM alunos
            WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12) > 18;

        v_nome           alunos.nome%TYPE;
        v_data_nascimento alunos.data_nascimento%TYPE;
    BEGIN
        OPEN alunos_cursor;

        LOOP
            FETCH alunos_cursor INTO v_nome, v_data_nascimento;
            EXIT WHEN alunos_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome || ', Data de Nascimento: ' || TO_CHAR(v_data_nascimento, 'DD/MM/YYYY'));
        END LOOP;

        CLOSE alunos_cursor;
    END;

    -- Cursor com filtro por curso
    PROCEDURE ListarAlunosPorCurso(p_id_curso IN NUMBER) IS
        CURSOR alunos_por_curso_cursor IS
            SELECT a.nome
            FROM alunos a
            JOIN matriculas m ON a.id = m.id_aluno
            WHERE m.id_curso = p_id_curso;

        v_nome alunos.nome%TYPE;
    BEGIN
        OPEN alunos_por_curso_cursor;

        LOOP
            FETCH alunos_por_curso_cursor INTO v_nome;
            EXIT WHEN alunos_por_curso_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome);
        END LOOP;

        CLOSE alunos_por_curso_cursor;
    END;
END PKG_ALUNO;
/

-- ================================
-- Pacote PKG_DISCIPLINA
-- ================================

CREATE OR REPLACE PACKAGE PKG_DISCIPLINA AS
    -- Procedure para cadastro de disciplina
    PROCEDURE CadastrarDisciplina(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER);

    -- Cursor para total de alunos por disciplina
    PROCEDURE TotalAlunosPorDisciplina;

    -- Cursor com média de idade por disciplina
    PROCEDURE MediaIdadePorDisciplina(p_id_disciplina IN NUMBER);

    -- Procedure para listar alunos de uma disciplina
    PROCEDURE ListarAlunosPorDisciplina(p_id_disciplina IN NUMBER);
END PKG_DISCIPLINA;
/
CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA AS
    -- Procedure para cadastro de disciplina
    PROCEDURE CadastrarDisciplina(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER) IS
    BEGIN
        INSERT INTO disciplinas (nome, descricao, carga_horaria)
        VALUES (p_nome, p_descricao, p_carga_horaria);
        COMMIT;
    END;

    -- Cursor para total de alunos por disciplina
    PROCEDURE TotalAlunosPorDisciplina IS
        CURSOR disciplinas_cursor IS
            SELECT d.nome, COUNT(m.id_aluno) AS total_alunos
            FROM disciplinas d
            JOIN matriculas m ON d.id = m.id_disciplina
            GROUP BY d.nome
            HAVING COUNT(m.id_aluno) > 10;

        v_nome          disciplinas.nome%TYPE;
        v_total_alunos  NUMBER;
    BEGIN
        OPEN disciplinas_cursor;

        LOOP
            FETCH disciplinas_cursor INTO v_nome, v_total_alunos;
            EXIT WHEN disciplinas_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Disciplina: ' || v_nome || ', Total de Alunos: ' || v_total_alunos);
        END LOOP;

        CLOSE disciplinas_cursor;
    END;

    -- Cursor com média de idade por disciplina
    PROCEDURE MediaIdadePorDisciplina(p_id_disciplina IN NUMBER) IS
        CURSOR idade_cursor IS
            SELECT AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, a.data_nascimento) / 12)) AS media_idade
            FROM alunos a
            JOIN matriculas m ON a.id = m.id_aluno
            WHERE m.id_disciplina = p_id_disciplina;

        v_media_idade NUMBER;
    BEGIN
        OPEN idade_cursor;

        LOOP
            FETCH idade_cursor INTO v_media_idade;
            EXIT WHEN idade_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Média de Idade: ' || NVL(v_media_idade, 0));
        END LOOP;

        CLOSE idade_cursor;
    END;

    -- Procedure para listar alunos de uma disciplina
    PROCEDURE ListarAlunosPorDisciplina(p_id_disciplina IN NUMBER) IS
        CURSOR alunos_cursor IS
            SELECT a.nome
            FROM alunos a
            JOIN matriculas m ON a.id = m.id_aluno
            WHERE m.id_disciplina = p_id_disciplina;

        v_nome alunos.nome%TYPE;
    BEGIN
        OPEN alunos_cursor;

        LOOP
            FETCH alunos_cursor INTO v_nome;
            EXIT WHEN alunos_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Aluno: ' || v_nome);
        END LOOP;

        CLOSE alunos_cursor;
    END;
END PKG_DISCIPLINA;
/

-- ================================
-- Pacote PKG_PROFESSOR
-- ================================

CREATE OR REPLACE PACKAGE PKG_PROFESSOR AS
    -- Cursor para total de turmas por professor
    PROCEDURE TotalTurmasPorProfessor;

    -- Function para total de turmas de um professor
    FUNCTION TotalTurmasProfessor(p_id_professor IN NUMBER) RETURN NUMBER;

    -- Function para professor de uma disciplina
    FUNCTION ProfessorPorDisciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2;
END PKG_PROFESSOR;
/
CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR AS
    -- Cursor para total de turmas por professor
    PROCEDURE TotalTurmasPorProfessor IS
        CURSOR professores_cursor IS
            SELECT p.nome, COUNT(t.id) AS total_turmas
            FROM professores p
            JOIN turmas t ON p.id = t.id_professor
            GROUP BY p.nome
            HAVING COUNT(t.id) > 1;

        v_nome          professores.nome%TYPE;
        v_total_turmas  NUMBER;
    BEGIN
        OPEN professores_cursor;

        LOOP
            FETCH professores_cursor INTO v_nome, v_total_turmas;
            EXIT WHEN professores_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Professor: ' || v_nome || ', Total de Turmas: ' || v_total_turmas);
        END LOOP;

        CLOSE professores_cursor;
    END;

    -- Function para total de turmas de um professor
    FUNCTION TotalTurmasProfessor(p_id_professor IN NUMBER) RETURN NUMBER IS
        v_total_turmas NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_total_turmas
        FROM turmas
        WHERE id_professor = p_id_professor;

        RETURN v_total_turmas;
    END;

    -- Function para professor de uma disciplina
    FUNCTION ProfessorPorDisciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2 IS
        v_nome_professor VARCHAR2(100);
    BEGIN
        SELECT p.nome
        INTO v_nome_professor
        FROM professores p
        JOIN disciplinas d ON p.id = d.id_professor
        WHERE d.id = p_id_disciplina;

        RETURN v_nome_professor;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Professor não encontrado';
    END;
END PKG_PROFESSOR;
/
