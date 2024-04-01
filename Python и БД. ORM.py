import sqlalchemy
import json
import sqlalchemy as sq
from sqlalchemy.orm import declarative_base, relationship, sessionmaker

Base = declarative_base()

class Publisher(Base):
    __tablename__ = 'publisher'
    id_publisher = sq.Column(sq.Integer, primary_key=True)
    name = sq.Column(sq.String(length=40), nullable=False)

class Book(Base):
    __tablename__ = 'book'
    id_book = sq.Column(sq.Integer, primary_key=True)
    title = sq.Column(sq.String(length=40), nullable=False)
    id_publisher = sq.Column(sq.Integer, sq.ForeignKey('publisher.id_publisher'), nullable=False)
    publisher = relationship(Publisher, backref='book')

class Shop(Base):
    __tablename__ = 'shop'
    id_shop = sq.Column(sq.Integer, primary_key=True)
    name = sq.Column(sq.String(length=40), nullable=False, unique=True)

class Stock(Base):
    __tablename__ = 'stock'
    id_stock = sq.Column(sq.Integer, primary_key=True)
    id_book = sq.Column(sq.Integer, sq.ForeignKey('book.id_book'), nullable=False)
    id_shop = sq.Column(sq.Integer, sq.ForeignKey('shop.id_shop'), nullable=False)
    count = sq.Column(sq.Integer, nullable=False)
    book = relationship(Book, backref='stock')
    shop = relationship(Shop, backref='stock')

class Sale(Base):
    __tablename__ = 'sale'
    id_sale = sq.Column(sq.Integer, primary_key=True)
    price = sq.Column(sq.Float, nullable=False)
    date_sale = sq.Column(sq.Date, nullable=False)
    id_stock = sq.Column(sq.Integer, sq.ForeignKey('stock.id_stock'), nullable=False)
    count = sq.Column(sq.Integer, nullable=False)
    stock = relationship(Stock, backref='sale')

def select_book(session, publisher):
    q = sq.select(Book.title, Shop.name, Sale.price, Sale.date_sale) \
        .select_from(Book) \
        .join(Publisher, Publisher.id_publisher == Book.id_publisher) \
        .join(Stock, Stock.id_book == Book.id_book) \
        .join(Shop, Shop.id_shop == Stock.id_shop) \
        .join(Sale, Sale.id_stock == Stock.id_stock) \
            .where(Publisher.name == publisher)
    for book in session.execute(q).all():
        print(f'Книга: {book.title:<20}| Магазин: {book.name:<20}| Цена: {book.price:<10}| Дата продажи: {book.date_sale}')

def create_tables(engine):
    Base.metadata.drop_all(engine)
    Base.metadata.create_all(engine)

DSN = "postgresql://postgres:postgres@localhost:5432/netology_db"
engine = sqlalchemy.create_engine(DSN)
create_tables(engine)

# сессия
Session = sessionmaker(bind=engine)
session = Session()

pr1 = Publisher(name='Pyshkin')
pr2 = Publisher(name='Blok')
session.add_all([pr1, pr2])
session.commit()

book1 = Book(title='Капитанская дочка', id_publisher=1)
book2 = Book(title='Руслан и Людмила', id_publisher=1)
book3 = Book(title='Евгений Онегин', id_publisher=1)
session.add_all([book1, book2, book3])
session.commit()

sh1 = Shop(name='Буквоед')
sh2 = Shop(name='Лабиринт')
sh3 = Shop(name='Книжный дом')
session.add_all([sh1, sh2, sh3])
session.commit()

st1 = Stock(id_book=1, id_shop=1, count=5)
st2 = Stock(id_book=2, id_shop=2, count=7)
st3 = Stock(id_book=3, id_shop=3, count=12)
session.add_all([st1, st2, st3])
session.commit()

sa1 = Sale(price=300,date_sale='9-11-2022',id_stock=1, count=23)
sa2 = Sale(price=400,date_sale='8-11-2022',id_stock=2, count=34)
sa3 = Sale(price=500,date_sale='7-11-2022',id_stock=3, count=45)
session.add_all([sa1, sa2, sa3])
session.commit()

select_book(session, 'Pyshkin')




