from MySQLdb import connect, OperationalError
from MySQLdb.cursors import DictCursor

try :
    # 1.연결
    db = connect(
            db='webdb',
            user = 'webdb',
            password = 'webdb',
            host = '127.0.0.1', #'localhost'
            port = 3306,
            charset = 'utf8') #MySQL에서는 'utf-8'로 쓰면 오류

    # 2. cursor 생성
    cursor = db.cursor(DictCursor)

    # 3. sql(insert문) 실행
    sql = 'select name, owner, species, gender, date_format(birth,"%y-%m-%d") as birth from pet'
    count = cursor.execute(sql)

    # 4. 결과 받아오기
    results = cursor.fetchall()

    # 5. 자원 정리
    cursor.close()
    db.close()

    # 결과 확인
    for result in results:
        print(result)

except OperationalError as e:
    print(f'에러 : {e}')