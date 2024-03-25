import psycopg2

def create_db(conn):
    with conn.cursor() as cursor:
        cursor.execute("""
                DROP TABLE client cascade;
                DROP TABLE phones;
                """)
        cursor.execute(''' 
            CREATE TABLE IF NOT EXISTS client(
            client_id SERIAL PRIMARY KEY,
            first_name VARCHAR(40) NOT NULL,
            last_name VARCHAR(40) NOT NULL,
            email VARCHAR(40) NOT NULL UNIQUE)''')
        cursor.execute(''' 
            CREATE TABLE IF NOT EXISTS phones(
            phone_id SERIAL PRIMARY KEY,
            client_id INTEGER REFERENCES client(client_id),
            phone VARCHAR(40) UNIQUE)''')
    conn.commit()

def add_client(conn, first_name, last_name, email, phone=None):
    with conn.cursor() as cursor:
        cursor.execute('''
            INSERT INTO client(first_name, last_name, email) VALUES (%s, %s, %s) RETURNING client_id''', (first_name, last_name, email))
        client_id = cursor.fetchone()[0]
        cursor.execute('''
            INSERT INTO phones(client_id, phone) VALUES (%s, %s)''', (client_id, phone))
        # cursor.execute('''
        #      SELECT * FROM client;
        #      ''')
        # print('fetchall', cursor.fetchall())
    conn.commit()


def add_phone(conn, first_name, phone):
    with conn.cursor() as cursor:
        cursor.execute('''
            SELECT client_id FROM client WHERE first_name = %s''', (first_name,))
        client_id = cursor.fetchone()[0]
        cursor.execute('''
            INSERT INTO phones(client_id, phone) VALUES (%s, %s)''', (client_id, phone))
        cursor.execute("""
                SELECT * FROM phones;
                """)
        print('Client add', cursor.fetchall())
    conn.commit()

def change_client(conn, first_name=None, last_name=None, email=None, phones=None):
        with conn.cursor() as cursor:
            if not first_name and not last_name and not email and not phones:
                print('Нет данных')
                return
            cursor.execute('''SELECT client_id FROM client WHERE first_name = %s''', (first_name,))
            client_id = cursor.fetchone()[0]
            if first_name:
                cursor.execute('''UPDATE client SET first_name = %s WHERE client_id = %s''', (first_name, client_id))
            if last_name:
                cursor.execute('''UPDATE client SET last_name = %s WHERE client_id = %s''', (last_name, client_id))
            if email:
                cursor.execute('''UPDATE client SET email = %s WHERE client_id = %s''', (email, client_id))
            if phones:
                cursor.execute('''UPDATE phones SET phone = %s WHERE client_id = %s''', (phones, client_id))
            cursor.execute("""
                            SELECT * FROM client;
                            """)
            print('Client change', cursor.fetchall())
        conn.commit()

def delete_phone(conn, first_name, phone):
    with conn.cursor() as cursor:
        cursor.execute('''
            SELECT client_id FROM client WHERE first_name = %s''', (first_name,))
        client_id = cursor.fetchone()[0]
        cursor.execute('''
            DELETE FROM phones WHERE client_id = %s AND phone = %s''', (client_id, phone))
        cursor.execute("""
            SELECT * FROM phones;
            """)
        print('Delete phone', cursor.fetchall())
    conn.commit()

def delete_client(conn, first_name):
    with conn.cursor() as cursor:
        cursor.execute('''
            DELETE FROM phones WHERE client_id = (SELECT client_id FROM client WHERE first_name = %s)''', (first_name,))
        cursor.execute('''
            DELETE FROM client WHERE first_name = %s''', (first_name,))
        cursor.execute("""
                    SELECT * FROM client;
                    """)
        print('Delete user', cursor.fetchall())
    conn.commit()

def find_client(conn, first_name=None, email=None, phone=None):
    with conn.cursor() as cursor:
        if not first_name and not email and not phone:
            print('Нет данных')
            return

        def print_result(search_query, client_name_n_email, phone):
            if not phone:
                print(
                    f'Results for "{search_query}":\n\tName: {client_name_n_email[0]}\n\tEmail: {client_name_n_email[1]}')
            elif search_query == phone:
                    print(
                        f'Results for "{search_query}":\n\tName: {client_name_n_email[0]}\n\tEmail: {client_name_n_email[1]}\n\tPhones: {phone}')
            else:
                phone_list = []
                for tuple in phone:
                    phone_list.append(tuple[0])
                phone_list = ', '.join(phone_list)
                print(
                    f'Results for "{search_query}":\n\tName: {client_name_n_email[0]}\n\tEmail: {client_name_n_email[1]}\n\tPhones: {phone_list}')

        if first_name:
            cursor.execute('''SELECT first_name, email FROM client WHERE first_name = %s''', (first_name,))
            client_name_n_email = cursor.fetchone()
            cursor.execute(
                '''SELECT phone FROM phones WHERE client_id = (SELECT client_id FROM client WHERE first_name = %s)''',
                (first_name,))
            phone = cursor.fetchall()
            print_result(first_name, client_name_n_email, phone)
            return
        if email:
            cursor.execute('''SELECT first_name, email FROM client WHERE email = %s''', (email,))
            client_name_n_email = cursor.fetchone()
            cursor.execute(
                '''SELECT phone FROM phones WHERE client_id = (SELECT client_id FROM client WHERE email = %s)''',
                (email,))
            phone = cursor.fetchall()
            print_result(email, client_name_n_email, phone)
            return
        if phone:
            cursor.execute('''SELECT first_name, email FROM client WHERE client_id IN
                (SELECT client_id FROM phones WHERE phone= %s)''', (phone,))
            client_name_n_email = cursor.fetchone()
            print_result(phone, client_name_n_email, phone)
            return
    conn.commit()

with psycopg2.connect(database="clients_db", user="postgres", password="postgres") as conn:
    # вызывайте функции здесь
    create_db(conn)
    add_client(conn, 'Albert', 'Uuu', 'aaaaa@mail.ee', '9872223344')
    add_client(conn, 'Andrey', 'Rrr', 'bbbbb@mail.ee', '9873334455')
    add_client(conn, 'Vasy', 'Ppp', 'wwwww@mail.ee', '9870000000')
    add_client(conn, 'Sergey', 'Www', 'ccccc@mail.ee')
    add_phone(conn, 'Andrey', '9876668899')
    change_client(conn, 'Albert', 'QQQQ', 'aaaaa@mail.ee', '9872223344')
    delete_phone(conn, 'Albert', '9872223344')
    delete_client(conn, 'Sergey')
    find_client(conn, first_name='Albert')
    find_client(conn, email='bbbbb@mail.ee')
    find_client(conn, phone='9870000000')
conn.close()

