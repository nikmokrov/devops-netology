# Домашнее задание к занятию "6.6. Troubleshooting"
## Задача 1

1. С помощью команды db.currentOp() находим **opid** зависшей CRUD операции. </br> 
Например:
```console
sample> db.currentOp()
{
  inprog: [
    {
      type: 'op',
      host: 'b2fb0eede135:27017',
      desc: 'JournalFlusher',
      active: true,
      currentOpTime: '2022-12-09T11:57:50.179+00:00',
      opid: 19951,
      op: 'none',
      ns: '',
      command: {},
      numYields: 0,
      locks: {},
      waitingForLock: false,
      lockStats: {},
      waitingForFlowControl: false,
      flowControlStats: {}
    },
  ],
  ok: 1
}
```

2. С помошью команды db.killOp() останавливаем зависшую CRUD операцию
```console
sample> db.killOp(19951)
{ info: 'attempting to kill op', ok: 1 }
```

Операции Read останавливаются на всем кластере. 
Операции Write, ассоциированные с серверной сессией, можно остановить путем уничтожения
сессии командой killSessions(<lsid>) (для этого нужно предварительно найти **lsid** (logical session
id) с помощью той же db.currentOp() ), а не ассоциированные с помощью db.killOp(<opid>) 
на каждом шарде кластера.

Для решения проблемы с долгими (зависающими) запросами нужно
проанализировать, почему запрос выполняется так долго.
Техническое решение заключается в задании ограничения времени выполнения запроса 
с помощью метода maxTimeMS(). Тогда MongoDB автоматически прервет операцию, 
превысившую лимит. </br> 
Например:
```console
db.location.find( { "town": { "$regex": "(Pine Lumber)",
                              "$options": 'i' } } ).maxTimeMS(30)
```

## Задача 2
```console
```

## Задача 3
```console

```
## Задача 4
```console

```
