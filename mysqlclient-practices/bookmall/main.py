from bookmall.models import model_category, model_book, model_member, model_cart, model_orders

print("--회원 리스트--")
# model_member.insert('이선무','dltjsam@gmail','01037039402')
# model_member.insert('둘리','dolli@gmail','01077775555')
# model_member.deletebyname('둘리')
results = model_member.findall()
for index, result in enumerate(results):
    print(f'{index + 1} : {result["name"]} , {result["email"]} , {result["phone"]}')

print()
print("--카테고리 리스트--")
# model_category.insert('문학')
# model_category.insert('IT')
# model_category.insert('요리')
results = model_category.findall()
for index, result in enumerate(results):
    print(f'{index + 1} : {result["name"]}')

print()
print("--상품 리스트--")
# model_book.insert('문학1','24000','1')
# model_book.insert('과학1','29000','2')
# model_book.insert('요리1','19000','3')
results = model_book.findall()
for index, result in enumerate(results):
    print(f'{index + 1} : {result["title"]} , {result["price"]} , {result["name"]}')

print()
print("--카트 리스트--")
# model_cart.insert(1,1,3)
results = model_cart.findall()
for index, result in enumerate(results):
    print(f'{index + 1} : {result["title"]} , {result["name"]} , {result["amount"]}권')

print()
print("--주문 리스트--")
# model_orders.insert('1','72000','경기도')
results = model_orders.findall()
for index, result in enumerate(results):
    print(f'{index + 1} : {result["name"]} , {result["title"]} , {result["amount"]}권 , {result["totalprice"]}원, {result["address"]}')