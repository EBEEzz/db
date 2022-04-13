/*
    문제1) 이름이 SMITH인 사원과 동일한 직급을 가진 사원의 정보를 출력하세요.
*/
SELECT
    *
FROM
    emp
WHERE
    job = (
        SELECT
            job
        FROM
            emp
        WHERE
            ename = 'SMITH'
    )
;


/*
    문제2) 회사 평균 급여보다 급여를 적게 받는 사원들의
        이름, 직급, 급여[, 회사평균급여] 를 조회하세요.
*/
SELECT
    ename 이름, job 직급, sal 급여, avg 회사평균급여
FROM
    emp,
    (
        SELECT
            ROUND(AVG(sal), 2) avg
        FROM
            emp
    )
WHERE
    sal < avg
ORDER BY
    sal
;


/*
    문제3) 사원들 중 급여가 제일 높은 사원의
        이름, 직급, 급여[, 최고급여] 를 조회하세요.
*/
SELECT
    ename 이름, job 직급, sal 급여, max 최고급여
FROM
    emp,
    (
        SELECT
            MAX(sal) max
        FROM
            emp
    )
WHERE
    sal = max
;


/*
    문제4) KING 사원보다 이후에 입사한 사원들의
        이름, 직급, 입사일[, KING 사원 입사일]을 조회하세요.
*/
SELECT
    ename 이름, job 직급, hiredate 입사일, HIR "KING 사원 입사일"
FROM
    emp,
    (
        SELECT
            hiredate HIR
        FROM
            emp
        WHERE
            ename = 'KING'
    )
WHERE
    hiredate > HIR
ORDER BY
    hiredate
;


/*
    문제5) 각 사원의 급여와 회사평균급여의 차를 출력하세요.
        이름, 급여, 급여의 차, 회사평균급여 로 조회하세요.
*/
SELECT
    ename 이름, sal 급여,
    (sal - avg) "급여의 차", avg 회사평균급여
FROM
    emp,
    (
        SELECT
            ROUND(AVG(sal), 2) avg
        FROM
            emp
    )
;


/*
    문제6) 부서별 급여의 합이 제일 높은 부서 사원들의
        이름, 직급, 부서번호, 부서이름, 부서급여합계, 부서원 수 를 조회하세요.
*/
SELECT
    ename 이름, job 직급, dno 부서번호, dname 부서이름,
    sum 부서급여합계, cnt "부서원 수"     

FROM
    emp, dept,
    (
        SELECT
            deptno dno, COUNT(*) cnt, SUM(sal) sum
        FROM
            emp
        GROUP BY
            deptno
    )
WHERE
    emp.deptno = dno
    AND emp.deptno = dept.deptno
    AND emp.deptno = (
        SELECT
            deptno
        FROM
            emp
        GROUP BY
            deptno
        HAVING
            SUM(sal) = (
                SELECT
                    max(SUM(sal))
                FROM
                    emp
                GROUP BY
                    deptno
            )
    )
;


/*
    문제7) 커미션을 받는 사원이 한명이라도 있는 부서의 사원들의
        이름, 직급, 부서번호, 커미션 을 조회하세요.
*/
SELECT
    ename 이름, job 직급, deptno 부서번호, comm 커미션
FROM
    emp
WHERE
    deptno IN (
        SELECT
            deptno
        FROM
            emp
        WHERE
            comm IS NOT NULL
            AND comm <> 0
    )
;


/*
    문제8) 회사평균급여보다 높고 이름이 4, 5글자인 사원들의
        이름, 급여, 이름글자길이[, 회사평균급여] 를 조회하세요.
*/
SELECT
    ename 이름, sal 급여, LENGTH(ename) 이름글자길이, avg 회사평균급여
FROM
    emp,
    (
        SELECT
            ROUND(AVG(sal), 2) avg
        FROM
            emp
    )
WHERE
    sal > avg
--    AND (ename LIKE '____' OR ename LIKE '_____')
    AND (LENGTH(ename) = 4 OR LENGTH(ename) = 5)
;


/*
    문제9) 이름의 글자수가 4글자인 사원과 같은 직급을 가진 사원들의
        이름, 직급, 급여 를 조회하세요.
*/
SELECT
    ename 이름, job 직급, sal 급여
FROM
    emp
WHERE
    job IN (
        SELECT
            job
        FROM
            emp
        WHERE
            LENGTH(ename) = 4
    )
ORDER BY
    job, LENGTH(ename)
;


/*
    문제10) 입사년도가 81년이 아닌 사원과 같은 부서에 있는 사원들의
        이름, 직급, 급여, 입사일, 부서번호 를 조회하세요.
*/
SELECT
    ename 이름, job 직급, sal 급여, hiredate 입사일, deptno 부서번호
FROM
    emp
WHERE
    deptno IN (
        SELECT
            deptno
        FROM
            emp
        WHERE
            TO_CHAR(hiredate, 'YY') <> '81'
    )
ORDER BY
    deptno, hiredate
;


/*
    문제11) 직급별 평균급여보다 한 직급에라도 급여를 많이 받는 사원의
        이름, 직급, 급여, 입사일 을 조회하세요.
*/
SELECT
    ename 이름, job 직급, sal 급여, hiredate 입사일
FROM
    emp
WHERE
    sal > any (
        SELECT
            ROUND(AVG(sal), 2)
        FROM
            emp
        GROUP BY
            job
    )
;


/*
    문제12) 모든 년도별 입사자의 평균 급여보다 많이 받는 사원들의
        이름, 직급, 급여, 입사년도 를 조회하세요.
*/
SELECT
    ename 이름, job 직급, sal 급여, TO_CHAR(hiredate, 'YYYY') 입사년도
FROM
    emp
WHERE
    sal > all (
        SELECT
            AVG(sal)
        FROM
            emp
        GROUP BY
            TO_CHAR(hiredate, 'YYYY')
    )
ORDER BY 
    sal
;


/*
    문제13) 최고급여자의 이름 글자수와 같은 글자수의 직원이 존재하면 모든 사원의
        이름, 이름글자수, 직급, 급여를 조회하고 존재하지 않으면 출력하지마세요.
*/
SELECT
    ename 이름, LENGTH(ename) 이름글자수, job 직급, sal 급여
FROM
    emp
WHERE
    EXISTS (
        SELECT
            *
        FROM
            emp
        WHERE 
            LENGTH(ename) = (
                SELECT
                    LENGTH(ename)
                FROM
                    emp
                WHERE
                    sal = (
                        SELECT
                            MAX(sal)
                        FROM
                            emp
                    )
            )
    )
ORDER BY
    LENGTH(ename), sal DESC
;

