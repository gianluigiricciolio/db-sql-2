-- GROUP BY QUERIES

-- 1. Contare quanti iscritti ci sono stati ogni anno

SELECT
    COUNT(`id`) AS `num_students`,
    YEAR(`enrolment_date`) AS `enrolment_year`
FROM
    `students`
GROUP BY
    `enrolment_year`;


-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio

SELECT
    COUNT(`id`) AS `num_teachers`,
    `office_address`
FROM
    `teachers`
GROUP BY
    `office_address`;


-- 3. Calcolare la media dei voti di ogni appello d'esame

SELECT
    AVG(`vote`) AS `avg_vote`,
    `exam_id`
FROM
    `exam_student`
GROUP BY
    `exam_id`;

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento

SELECT
    COUNT(`id`) AS `degrees`,
    `department_id`
FROM
    `degrees`
GROUP BY
    `department_id`;

-- JOIN QUERIES

-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia

SELECT
    `students`.`name`,
    `students`.`surname`,
    `degrees`.`name`
FROM
    `students`
INNER JOIN `degrees` ON `degrees`.`id` = `students`.`degree_id`
WHERE
    `degrees`.`name` = 'Corso di Laurea in Economia';

-- 2. Selezionare tutti i Corsi di Laurea Magistrale del Dipartimento di Neuroscienze

SELECT
    `degrees`.`name`,
    `degrees`.`level`,
    `departments`.`name`
FROM
    `degrees`
INNER JOIN `departments` ON `departments`.`id` = `degrees`.`department_id`
WHERE
    `degrees`.`level` = 'magistrale' AND `departments`.`name` = 'Dipartimento di Neuroscienze'


-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)

SELECT
    `teachers`.`name`,
    `teachers`.`surname`,
    `teachers`.`id`,
    `courses`.`name`
FROM
    `teachers`
INNER JOIN `course_teacher` ON `teachers`.`id` = `course_teacher`.`teacher_id`
INNER JOIN `courses` ON `courses`.`id` = `course_teacher`.`course_id`
WHERE
    `teachers`.`id` = 44;
    

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome

SELECT
    `students`.*,
    `degrees`.`name`,
    `degrees`.`department_id`,
    `departments`.`name`
FROM
    `students`
INNER JOIN `degrees` ON `degrees`.`id` = `students`.`degree_id`
INNER JOIN `departments` ON `departments`.`id` = `degrees`.`department_id`
ORDER BY
    `students`.`surname`,
    `students`.`name`;


-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti

SELECT
    `degrees`.`id`,
    `degrees`.`department_id`,
    `degrees`.`name`,
    `courses`.`name`,
    `teachers`.`name`,
    `teachers`.`surname`
FROM
    `degrees`
INNER JOIN `courses` ON `degrees`.`id` = `courses`.`degree_id`
INNER JOIN `course_teacher` ON `courses`.`id` = `course_teacher`.`course_id`;
INNER JOIN `teachers` ON `teachers`.`id` = `course_teacher`.`teacher_id`


-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)

SELECT DISTINCT
    `teachers`.`id`,
    `teachers`.`name`,
    `teachers`.`surname`,
    `departments`.`name`
FROM
    `teachers`
INNER JOIN `course_teacher` ON `teachers`.`id` = `course_teacher`.`teacher_id`
INNER JOIN `courses` ON `course_teacher`.`course_id` = `courses`.`id`
INNER JOIN `degrees` ON `degrees`.`id` = `courses`.`degree_id`
INNER JOIN `departments` ON `departments`.`id` = `degrees`.`department_id`
WHERE
    `departments`.`name` = 'Dipartimento di matematica'
ORDER BY
    `teachers`.`id`;

-- 7. BONUS: Selezionare per ogni studente il numero di tentativi sostenuti per ogni esame, stampando anche il voto massimo. Successivamente, filtrare i tentativi con voto minimo 18.

SELECT
    `students`.`id`,
    `students`.`name`,
    `students`.`surname`,
    COUNT(`exam_student`.`vote`) AS `attempt_count`,
    MAX(`exam_student`.`vote`) AS `max_grade`
FROM
    `students`
INNER JOIN `exam_student` ON `students`.`id` = `exam_student`.`student_id`
INNER JOIN `exams` ON `exams`.`id` = `exam_student`.`exam_id`
GROUP BY
    `students`.`id`,
    `exams`.`course_id`
HAVING
    `max_grade` > 18    
ORDER BY
    `students`.`surname`,
    `students`.`name`;