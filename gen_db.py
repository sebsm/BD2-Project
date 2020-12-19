import psycopg2
import random
from datetime import datetime, timedelta


def random_date(start, end):
    delta = end - start
    int_delta = delta.days
    random_days = random.randrange(int_delta)
    dt = start + timedelta(days=random_days)
    return dt


def db_connect():
    conn = psycopg2.connect(
        host="localhost",
        database="BD2",
        user="postgres",
        password="s197328645S!")

    cur = conn.cursor()
    cur.execute('SELECT version()')
    response = cur.fetchall()
    print(response)

    return conn


def generate_workers(num):
    pracownicy = []
    imiona = ['Adam', 'Bartosz', 'Damian', 'Jerzy', 'Arleta', 'Beata', 'Dominika', 'Julia']
    nazwiska = ['Kowalski', 'Nowak', 'Grzeskowiak', 'Adamiuk', 'Romanov', 'Parowka']
    stanowiska = ['junior', 'mid', 'senior', 'manager', 'CEO']
    id_komisji = range(1, 5)
    for id in range(num):
        pracownicy.append({
            'id': id,
            'imie': random.choice(imiona),
            'nazwisko': random.choice(nazwiska),
            'stanowisko': random.choice(stanowiska),
            'data_rozpoczecia': random_date(datetime(2015,1,1), datetime(2020,1,1)),
            'pesel': random.randint(10000000000, 99999999999),
            'pensja': random.randint(3,12) * 1000,
            'id_komisji': random.choice(id_komisji)
        })
    return pracownicy


def generate_budget(num):
    budgets = []
    categories = ['pracowniczy', 'socjalny', 'swiateczny', 'prezesowski']
    limits = [10000, 15000, 20000, 25000, 30000]
    for id in range(num):
        budgets.append({
            'id': id,
            'category': random.choice(categories),
            'limit': random.choice(limits),
        })
    return budgets


def generate_uses(num):
    uses = []
    for id in range(num):
        uses.append({
            'used': 50000,
            'low_income': bool(random.getrandbits(1)),
            'budget_id': random.randint(1, 5),
            'worker_id': random.randint(1, 10)
        })
    return uses


def genetate_proposals(num):
    proposals = []
    decisions = ['zaakceptowane', 'odrzucone']
    comments = ['Prosze o akceptacje mojego wniosku', 'Zwracam sie z uprzejma prosba o przyznanie mi funduszy',
                'Z niecierpliwoscia oczekuje na odpowiedz', 'Panie prezesie, wiem ze pana stac']
    comitee_comments = ['Przekroczono budzet', 'Nie stac nas przez pandemie', 'Przyznano wniosek bez zarzutow']
    for id in range(num):
        proposals.append({
            'id': id,
            'decision': random.choice(decisions),
            'comment': random.choice(comments),
            'comitee_comment': random.choice(comitee_comments),
            'submit_date': random_date(datetime(2019,1,1), datetime(2020,1,1)),
            'close_date': random_date(datetime(2019,1,1), datetime(2020,1,1)),
            'worker_id': random.randint(1, 10),
            'service_id': random.randint(1, 5),
            'comitee_id': random.randint(1, 5)
        })
    return proposals


def generate_attachments(num):
    attachments = []
    contents = ['C://Users/AdamNowak/zalacznik.pdf', 'C://Users/AlicjaKowalczyk/attachment.docx']
    for id in range(num):
        attachments.append({
            'id': id,
            'content': random.choice(contents),
            'proposal_id': random.randint(1, 5),
        })
    return attachments


def generate_services(num):
    services = []
    service_types = ['Opieka_medyczna', 'Pomoc_mieszkaniowa', 'Zapomoga', 'Impreza_kulturalna', 'Refundacja_wakacji']
    required_documents = ['zaswiadczenie', 'zalacznik', 'skan', 'zdjecie']
    for id in range(num):
        services.append({
            'id': id,
            'service_type': service_types[id],
            'required_document': random.choice(required_documents),
            'max_value': random.randint(1, 15) * 100
        })
    return services


def generate_single_service(num):
    services = []
    for id in range(num):
        services.append({
            'id': id,
            'service_id': random.randint(1, 5),
            'expected_refund': random.randint(1, 10) * 100
        })
    return services


def load_workers(cur, num=10):
    workers = generate_workers(num)
    for worker in workers:
        query = """INSERT INTO pracownik(imie, nazwisko, stanowisko, data_rozpoczecia_pracy, pesel,
                pensja, komisja_id_komisji)
                VALUES ('{}', '{}', '{}', timestamp '{}', '{}', {}, {});""".format(
            worker['imie'], worker['nazwisko'], worker['stanowisko'], worker['data_rozpoczecia'],
            worker['pesel'], worker['pensja'], worker['id_komisji'])
        cur.execute(query)
        print(query)


def load_commitees(cur, num=5):
    for id in range(num):
        query = "INSERT INTO komisja(id_komisji) VALUES ({});".format(id+1)
        cur.execute(query)
        print(query)


def load_budgets(cur, num=5):
    budgets = generate_budget(num)
    for budget in budgets:
        query = """INSERT INTO budzet(
                kategoria, prog)
                VALUES ('{}', {});""".format(
            budget['category'], budget['limit'])
        cur.execute(query)
        print(query)


def load_uses(cur, num=5):
    uses = generate_uses(num)
    for use in uses:
        query = """INSERT INTO wykorzystanie(
                wykorzystanie, niski_dochod, budzet_id_budzetu, pracownik_id_pracownika)
                VALUES ({}, {}, {}, {});""".format(
            use['used'], use['low_income'], use['budget_id'], use['worker_id'])
        cur.execute(query)
        print(query)


def load_proposals(cur, num=10):
    proposals = genetate_proposals(num)
    for proposal in proposals:
        query = """INSERT INTO wniosek(
                decyzja, uwaga, uwaga_komisji, data_zlozenia, data_zamkniecia, pracownik_id_pracownika,
                uslugi_id_uslugi, komisja_id_komisji)
                VALUES ('{}', '{}', '{}', timestamp '{}', timestamp '{}', {}, {}, {});""".format(
            proposal['decision'], proposal['comment'], proposal['comitee_comment'],
            proposal['submit_date'], proposal['close_date'], proposal['worker_id'], proposal['service_id'],
            proposal['comitee_id'])
        cur.execute(query)
        print(query)


def load_attachments(cur, num=5):
    attachments = generate_attachments(num)
    for attachment in attachments:
        query = """INSERT INTO zalaczniki(
                tresc, wniosek_id_wniosku)
                VALUES ('{}', {});""".format(
            attachment['content'], attachment['proposal_id'])
        cur.execute(query)
        print(query)


def load_services(cur, num=5):
    services = generate_services(num)
    for service in services:
        query = """INSERT INTO uslugi(
                rodzaj_uslugi, wymagany_dokument, max_wartosc)
                VALUES ('{}', '{}', {});""".format(
            service['service_type'], service['required_document'], service['max_value'])
        cur.execute(query)
        print(query)


def load_impreza_kulturalna(cur, num=5):
    services = generate_single_service(num)
    for service in services:
        query = """INSERT INTO impreza_kulturalna(
                id_uslugi, id_imprezy, oczekiwana_wartosc)
                VALUES ({}, {}, {});""".format(
            4, service['id'], service['expected_refund'])
        cur.execute(query)
        print(query)


def load_opieka_medyczna(cur, num=5):
    services = generate_single_service(num)
    for service in services:
        query = """INSERT INTO opieka_medyczna(
                id_uslugi, id_opieki_medycznej, oczekiwana_refundacja)
                VALUES ({}, {}, {});""".format(
            1, service['id'], service['expected_refund'])
        cur.execute(query)
        print(query)


def load_pomoc_mieszkaniowa(cur, num=5):
    services = generate_single_service(num)
    for service in services:
        query = """INSERT INTO pomoc_mieszkaniowa(
                id_uslugi, id_pomocy_mieszkaniowej, oczekiwana_wartosc, dlugosc)
                VALUES ({}, {}, {}, {});""".format(
            2, service['id'], service['expected_refund'], random.randint(1, 10))
        cur.execute(query)
        print(query)


def load_refundacja_wakacji(cur, num=5):
    services = generate_single_service(num)
    for service in services:
        query = """INSERT INTO refundacja_wakacji(
                id_uslugi, id_refundacji, wartosc_oczrekiwana)
                VALUES ({}, {}, {});""".format(
            5, service['id'], service['expected_refund'])
        cur.execute(query)
        print(query)


def load_zapomoga(cur, num=5):
    services = generate_single_service(num)
    for service in services:
        query = """INSERT INTO zapomoga(
                id_uslugi, id_zapomogi, oczekiwana_wartosc)
                VALUES ({}, {}, {});""".format(
            3, service['id'], service['expected_refund'])
        cur.execute(query)
        print(query)


def load_parameters(cur):
    query = """INSERT INTO public.parametry(
            parametr_niskodochodowy, oprocentowanie_uslug)
            VALUES (1.5, 4.2);"""
    cur.execute(query)
    print(query)


def main():
    conn = db_connect()
    cur = conn.cursor()

    load_commitees(cur)
    load_workers(cur)
    load_budgets(cur)
    load_uses(cur)
    load_services(cur)
    load_proposals(cur)
    load_attachments(cur)
    load_parameters(cur)
    load_opieka_medyczna(cur)
    load_refundacja_wakacji(cur)
    load_impreza_kulturalna(cur)
    load_zapomoga(cur)
    load_pomoc_mieszkaniowa(cur)

    conn.commit()
    cur.close()
    conn.close()


if __name__ == "__main__":
    main()