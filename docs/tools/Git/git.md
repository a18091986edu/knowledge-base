## commit
- git commit --amend - добавить изменения в индексе в предыдущий коммит
- git commit --amend --no-edit



## история

- git log --stat
- git log --since="2012-01-01" --until="2012-12-31"
- git clog --graph
- git shortlog
- git log oneline 
- git log oneline filename - покажет в каких коммитах затрагивался данный файл
- git show [id_commit] # детальная информация об указанном коммите


## изменение истории

- git reflog - ведет историю локальных изменений


## Отмена изменений
- git reset # очищает индекс
- git reset [file] - убрать конкретный файл из индекса
- git reset --hard - удалить все изменения после последнего коммита
- git reset --harf [commit_id] - вернуться к состоянию после указанного коммита
- git reset HEAD~1 - отменить последний коммит, сохраняя сами изменения 
- git reset HEAD~1 --hard/--mixed/--soft


- git revert [commit_id] - создает новый коммит с изменениями обратными тому коммиту, который мы указали в качестве аргумента
- git revert --abort - если конфликты, которые мы не хотим решать 
- git revert [commit_id]..[commit_id] - откатить серию коммитов
- git revert [commit_id] --no-commit - не создавать новый коммит, изменения попадают в индекс


## удаление файлов

- git rm file - удаление и из дирректории и из индекса одной коммандой
- git rm dir -r 
- git clean -f - удаление неотслеживаемых файлов
- git clean -df - удаление пустых папок из репозитория
- git clean -df -f -n - предварительно отобразить что будет удалено


## просмотр изменений

- git diff --word-diff
- git difftool
- git show


## клонирование

- git clone 
- git clone --depth=1
- git clone --bare


## копирование чужого репозитория

- git fork
- 
