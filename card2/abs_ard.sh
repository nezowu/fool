    #!/bin/bash
    # pick-card.sh
    # Пример выбора случайного элемента массива.
    # Выбор случайной карты из колоды.
    Suites="Треф
    Бубей
    Червей
    Пик"
    Denominations="2
    3
    4
    5
    6
    7
    8
    9
    10
    Валет
    Дама
    Король
    Туз"
    suite=($Suites)                # Инициализация массивов.
    denomination=($Denominations)
    num_suites=${#suite[*]}        # Количество элементов массивов.
    num_denominations=${#denomination[*]}
    echo -n "${denomination[$((RANDOM%num_denominations))]} "
    echo ${suite[$((RANDOM%num_suites))]}
    # $bozo sh pick-cards.sh
    # Валет Треф
    exit 0
