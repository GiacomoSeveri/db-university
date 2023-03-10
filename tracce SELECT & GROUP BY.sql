-- ---------------------------------------  QUERY CON SELECT

-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT * 
FROM `students`  
WHERE `date_of_birth` LIKE '1990-%';

-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT * 
FROM `courses` 
WHERE `cfu` > 10;

-- 3. Selezionare tutti gli studenti che hanno più di 30 anni
SELECT * 
FROM students 
WHERE YEAR(`date_of_birth`) < YEAR(DATE_SUB(CURRENT_DATE(), INTERVAL 30 YEAR));

-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT * 
FROM `courses` 
WHERE `period` LIKE 'I semestre' and `year` LIKE '1';

-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
SELECT * 
FROM `exams` 
WHERE `date` = '2020-06-20' AND HOUR(`hour`) >= 14;

-- 6. Selezionare tutti i corsi di laurea magistrale (38)
SELECT * 
FROM `degrees`
WHERE `level` = 'magistrale';

-- 7. Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(*) 
FROM `departments`;

-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT COUNT(*) AS 'Insegnanti'
FROM `teachers`
WHERE `phone` IS NULL;


-- ------------------------------------------ QUERY CON GROUP BY


-- 1. Contare quanti iscritti ci sono stati ogni anno
SELECT COUNT(*) AS 'new sub', YEAR(`enrolment_date`) AS `year` 
FROM `students` 
GROUP BY(`year`);

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT COUNT(*) AS 'teachers' , `office_address` AS 'office' 
FROM `teachers` 
GROUP BY(`office`);

-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT `exam_id`, ROUND(AVG(`vote`)) AS 'vote average'
FROM `exam_student` 
GROUP BY(`exam_id`);

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT COUNT(`name`) AS 'course name', `department_id` AS 'departments' 
FROM `degrees` 
GROUP BY(`department_id`);


-- ------------------------------------------ QUERY CON JOIN


--Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT `students`.`name`, `students`.`surname`, `degrees`.`name` AS 'courses name' 
FROM `degrees` 
JOIN `students` 
ON `degrees`.`id` = `students`.`degree_id` 
WHERE `degrees`.`name` = 'Corso di Laurea in Economia';

--Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze
SELECT `degrees`.`name` AS 'courses', `departments`.`name`AS 'department' 
FROM `departments` 
JOIN `degrees` 
ON `departments`.`id` = `degrees`.`department_id` 
WHERE `departments`.`name` = 'Dipartimento di Neuroscienze';

--Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT `courses`.`name` AS 'courses name', `teachers`.`name` 
FROM `courses` 
JOIN `course_teacher` 
ON `courses`.`id` = `course_teacher`.`course_id` 
JOIN `teachers` 
ON `teachers`.`id`= `course_teacher`.`teacher_id` 
WHERE `teachers`.`name` = 'Fulvio'
AND `teachers`.`surname` = 'Amato';

--Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT `students`.`surname`,`students`.`name`,`degrees`.`name` AS 'courses name', `departments`.`name` AS 'department' 
FROM `departments` 
JOIN `degrees` 
ON `departments`.`id`= `degrees`.`department_id` 
JOIN `students` 
ON `degrees`.`id` = `students`.`degree_id` 
ORDER BY `students`.`name` ASC;

--Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT `degrees`.`name` AS 'degrees name', `courses`.`name` AS 'courses name', `teachers`.`name`, `teachers`.`surname` 
FROM `degrees` 
JOIN `courses` 
ON `degrees`.`id` = `courses`.`degree_id` 
JOIN `course_teacher` 
ON `courses`.`id` = `course_teacher`.`course_id` 
JOIN `teachers` 
ON `teachers`.`id` = `course_teacher`.`teacher_id`;

--Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT DISTINCT `teachers`.`surname`, `teachers`.`name`, `departments`.`name` AS 'department' 
FROM `teachers` 
JOIN `course_teacher` 
ON `teachers`.`id` = `course_teacher`.`teacher_id` 
JOIN `courses` 
ON `courses`.`id` = `course_teacher`.`course_id` 
JOIN `degrees` 
ON `degrees`.`id` = `courses`.`degree_id` 
JOIN `departments`
ON `departments`.`id` = `degrees`.`department_id` 
WHERE `departments`.`name` = 'Dipartimento di Matematica';
