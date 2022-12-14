-- subquery
-- 1) select절의 서브쿼리는 실효성의 좀 떨어져서 예제x


-- 2) from절의 서브쿼리
select now() as a, sysdate() as b, (3+1) as c;

select s.a, s.b, s.c
	from (select now() as a, sysdate() as b, 3+1 as c) s; -- from절의 서브쿼리를 table로 이해하면 쉬움
    
    

-- 3) where절의 서브쿼리
-- 예제) 현재 Fai Bale이 근무하는 부서의 직원들의 사번,이름을 출력하세요.

-- 서브쿼리를 몰랐을때 푸는법
select dept_no
	from dept_emp a, employees b
    where a.emp_no = b.emp_no
		and concat(first_name,' ',last_name) = 'Fai Bale' -- 일단 Fai Bale이 속해있는 부서를 구함
        and a.to_date like '9999%';
        
select b.emp_no, b.first_name
	from dept_emp a, employees b
    where a.emp_no = b.emp_no
		and a.to_date like '9999%'
        and a.dept_no = 'd004';

-- sol) where절 안에 첫번째 select문을 넣어줌
-- 서브쿼리에 단일행연산자 '='을 썼기에 서브쿼리의 값은 하나로 딱 떨어져야함 ('d004')
select b.emp_no, b.first_name
	from dept_emp a, employees b
    where a.emp_no = b.emp_no
		and a.to_date like '9999%'
        and a.dept_no = (select dept_no
						from dept_emp a, employees b
						where a.emp_no = b.emp_no
							and concat(first_name,' ',last_name) = 'Fai Bale'
							and a.to_date like '9999%');
                            


-- 3-1) 단일행 연산자 : =, !=, >, <, >=, <=
-- 실습문제1 : 현재, 전체사원의 평균연봉보다 적은 급여를 받고있는 사원의 이름,급여를 출력하세요.
select avg(salary)
	from salaries
    where to_date like '9999%'; -- 현재, 전체사원의 평균연봉을 일단 구함
    
select a.first_name, b.salary
	from employees a, salaries b
    where a.emp_no = b.emp_no
		and b.to_date like '9999%'
        and salary < (select avg(salary) -- salary가 평균연봉보다 작다는 것을 나타내줌
						from salaries
						where to_date like '9999%');



-- 실습문제2 : 현재, 가장 적은 평균급여를 받고있는 직책과 그 급여를 출력하세요.
-- 1) 일단, 직책별 평균급여를 구함
select a.title, avg(salary) as avg_salary
	from titles a, salaries b
    where a.emp_no = b.emp_no
        and a.to_date like '9999%'
        and b.to_date like '9999%'
	group by a.title;

-- 2) 직책별 평균급여중 제일 작은거 구함
select min(a.avg_salary)
	from (select a.title, avg(salary) as avg_salary -- 첫번째 구한 리스트를 하나의 테이블로 봐줌
			from titles a, salaries b
			where a.emp_no = b.emp_no
				and a.to_date like '9999%'
				and b.to_date like '9999%'
			group by a.title) a;

-- 3) sol1 : 서브쿼리
select a.title, avg(salary) as avg_salary
	from titles a, salaries b
    where a.emp_no = b.emp_no
        and a.to_date like '9999%'
        and b.to_date like '9999%'
	group by a.title
    having avg_salary = (select min(a.avg_salary) -- 직책별 평균급여 중 가장 작은 평균급여와 같은 직책을 고른다는 뜻
							from (select a.title, avg(salary) as avg_salary
									from titles a, salaries b
										where a.emp_no = b.emp_no
										and a.to_date like '9999%'
										and b.to_date like '9999%'
									group by a.title) a);
                                    
--   sol2 : top-k를 쓴다 -> limit(시작지점,범위)
select a.title, avg(salary) as avg_salary
	from titles a, salaries b
    where a.emp_no = b.emp_no
        and a.to_date like '9999%'
        and b.to_date like '9999%'
	group by a.title
order by avg_salary
	limit 0,1; -- 평균급여 오름차순 한 것을 위에서 첫번째꺼 한개만 고른다는 뜻



-- 3-2) 복수행 연산자 : in, not, in, any, all
-- any 사용법
-- 1. =any : in과 동일
-- 2. >any, >any : 최소값 
-- 3. <any, <=any : 최대값
-- 4. !=any : not in과 동일

-- all 사용법
-- 1. =all : x
-- 2. >all, >=all : 최대값 (서브쿼리에 있는 모든 데이터보다 커야함)
-- 3. <all. <=all : 최소값 (서브쿼리에 있는 모든 데이터보다 작아야함)
-- 4. !=all : 



-- 실습문제3 : 현재 급여가 50000이상인 직원의 이름과 급여를 출력하세요.
-- sol1)
select a.first_name, b.salary
	from employees a, salaries b
    where a.emp_no = b.emp_no
		and b.to_date like '9999%'
        and b.salary >= 50000
order by b.salary;

-- sol2)
select a.first_name, b.salary
	from employees a, salaries b
    where a.emp_no = b.emp_no
		and b.to_date like '9999%'
        and (a.emp_no, b.salary) in (select emp_no, salary -- in은 포함되어있느냐의 개념
										from salaries
										where to_date like '9999%'
											and salary >= 50000)
order by b.salary;

-- 실습문제4 : 현재, 각 부서별로 최고 월급을 받는 직원의 이름, 부서이름, 월급을 출력하세요.
-- 출력예시 : 둘리 총무 200, 또치 개발 400

select a.dept_no, max(salary) as max_salary -- 각 부서별 최고월급을 일단 구함
	from dept_emp a, salaries b
    where a.emp_no = b.emp_no
		and a.to_date like '9999%'
        and b.to_date like '9999%'
	group by a.dept_no;
    
-- sol1) where절 서브쿼리
select c.first_name, a.dept_name, d.salary
	from departments a, dept_emp b, employees c, salaries d
    where a.dept_no = b.dept_no
		and b.emp_no = c.emp_no
        and c.emp_no = d.emp_no
        and b.to_date like '9999%'
        and d.to_date like '9999%'
        and (a.dept_no, d.salary) in (select a.dept_no, max(salary) as max_salary
										from dept_emp a, salaries b
										where a.emp_no = b.emp_no
											and a.to_date like '9999%'
											and b.to_date like '9999%'
									  group by a.dept_no);
                                      
-- sol2) from절 서브쿼리
select c.first_name, a.dept_name, d.salary
	from departments a,
		 dept_emp b,
         employees c,
         salaries d,
         (select a.dept_no, max(salary) as max_salary
			from dept_emp a, salaries b
			where a.emp_no = b.emp_no
				and a.to_date like '9999%'
				and b.to_date like '9999%'
			group by a.dept_no) e
    where a.dept_no = b.dept_no
		and b.emp_no = c.emp_no
        and c.emp_no = d.emp_no
        and e.dept_no = a.dept_no
        and b.to_date like '9999%'
        and d.to_date like '9999%'
        and e.max_salary = d.salary;