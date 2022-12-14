"" Last update: 23.03.2016 08:44
"" .vimrc  файл конфирурации для текстового редактора VIM
"" dimio (http://dimio.org)
"" Подробности по адресу:
"" http://dimio.org/fajl-nastrojki-vim-vimrc-dlya-linux-i-windows.html
"=====================================================================
"НАСТРОЙКИ ВНЕШНЕГО ВИДА И БАЗОВЫЕ НАСТРОЙКИ РЕДАКТОРА
set nocompatible " отключить режим совместимости с классическим Vi
set scrolloff=3 " сколько строк внизу и вверху экрана показывать при скроллинге
"set background=dark " установить цвет фона
"цветовая схема по умолчанию (при вводе в режиме команд
"по табуляции доступно автодополнение имён схем). af, desert
colorscheme desert
set wrap " (no)wrap - динамический (не)перенос длинных строк
set linebreak " переносить целые слова
set hidden " не выгружать буфер когда переключаешься на другой
set mouse=a " включает поддержку мыши при работе в терминале (без GUI)
set mousehide " скрывать мышь в режиме ввода текста
set showcmd " показывать незавершенные команды в статусбаре (автодополнение ввода)
set mps+=<:> " показывать совпадающие скобки для HTML-тегов
set showmatch " показывать первую парную скобку после ввода второй
set autoread " перечитывать изменённые файлы автоматически
set t_Co=256 " использовать больше цветов в терминале
set confirm " использовать диалоги вместо сообщений об ошибках
"" Автоматически перечитывать конфигурацию VIM после сохранения
autocmd! bufwritepost $MYVIMRC source $MYVIMRC
"" Формат строки состояния
" fileformat - формат файла (unix, dos); fileencoding - кодировка файла;
" encoding - кодировка терминала; TYPE - тип файла, затем коды символа под курсором;
" позиция курсора (строка, символ в строке); процент прочитанного в файле;
" кол-во строк в файле;
set statusline=%F%m%r%h%w\ [FF,FE,TE=%{&fileformat},%{&fileencoding},%{&encoding}\]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"Изменяет шрифт строки статуса (делает его не жирным)
hi StatusLine gui=reverse cterm=reverse
set laststatus=2 " всегда показывать строку состояния
set noruler "Отключить линейку
"" Подсвечивать табы и пробелы в конце строки
set list " включить подсветку
set listchars=tab:>-,trail:- " установить символы, которыми будет осуществляться подсветка
"Проблема красного на красном при spellchecking-е решается такой строкой в .vimrc
highlight SpellBad ctermfg=Black ctermbg=Red
au BufWinLeave *.* silent mkview " при закрытии файла сохранить 'вид'
au BufWinEnter *.* silent loadview " при открытии - восстановить сохранённый
set backspace=indent,eol,start " backspace обрабатывает отступы, концы строк
set sessionoptions=curdir,buffers,tabpages " опции сессий - перейти в текущую директорию, использовать буферы и табы
set noswapfile " не использовать своп-файл (в него скидываются открытые буферы)
set browsedir=current
set visualbell " вместо писка бипером мигать курсором при ошибках ввода
set clipboard=unnamed " во избежание лишней путаницы использовать системный буфер обмена вместо буфера Vim
set backup " включить сохранение резервных копий
autocmd! bufwritepre * call BackupDir() " сделаем резервную копию перед записью буфера на диск
set title " показывать имя буфера в заголовке терминала
set history=128 " хранить больше истории команд
set undolevels=2048 " хранить историю изменений числом N
set whichwrap=b,<,>,[,],l,h " перемещать курсор на следующую строку при нажатии на клавиши вправо-влево и пр.
"set virtualedit=all " позволяет курсору выходить за пределы строки
let c_syntax_for_h="" " необходимо установить для того, чтобы *.h файлам присваивался тип c, а не cpp
" При вставке фрагмента сохраняет отступ
set pastetoggle=
"подсвечивает все слова, которые совпадают со словом под курсором.
autocmd CursorMoved * silent! exe printf("match Search /\\<%s\\>/", expand(''))


"НАСТРОЙКИ ПЕРЕМЕННЫХ ОКРУЖЕНИЯ
if has('win32')
   let $VIMRUNTIME = $HOME.'\Programs\Vim\vim72'
   source $VIMRUNTIME/mswin.vim
else
   let $VIMRUNTIME = $HOME.'/.vim'
endif
" запуск плагина NeoBundle
if has('vim_starting')
    set runtimepath+=$VIMRUNTIME/bundle/neobundle.vim/
endif
call neobundle#rc(expand("$VIMRUNTIME/bundle/"))
NeoBundleFetch 'Shougo/neobundle.vim'

"ПЛАГИНЫ
"Для отключения - закомментировать строку
"Примеры подключения разных типов репозиториев см. на
"http://github.com/Shougo/neobundle.vim
"
"Репозитории на github
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/unite.vim'
"Репозитории vim-скриптов
"NeoBundle 'L9'
"Проверка установки/подключения плагинов
NeoBundleCheck


"НАСТРОЙКИ ПОИСКА ТЕКСТА В ОТКРЫТЫХ ФАЙЛАХ
set ignorecase " ics - поиск без учёта регистра символов
set smartcase " - если искомое выражения содержит символы в верхнем регистре - ищет с учётом регистра, иначе - без учёта
set nohlsearch " (не)подсветка результатов поиска (после того, как поиск закончен и закрыт)
set incsearch " поиск фрагмента по мере его набора
" поиск выделенного текста (начинать искать фрагмент при его выделении)
vnoremap * :call VisualSearch()//
vnoremap # :call VisualSearch()?/


"НАСТРОЙКИ СВОРАЧИВАНИЯ БЛОКОВ ТЕКСТА (фолдинг)
set foldenable " включить фолдинг
"set foldmethod=syntax " определять блоки на основе синтаксиса файла
set foldmethod=indent " определять блоки на основе отступов
set foldcolumn=3 " показать полосу для управления сворачиванием
set foldlevel=1 " Первый уровень вложенности открыт, остальные закрыты
set foldopen=all " автоматическое открытие сверток при заходе в них
set tags=tags\ $VIMRUNTIME/systags " искать теги в текущй директории и в указанной (теги генерируются ctags)


"НАСТРОЙКИ РАБОТЫ С ФАЙЛАМИ
"Кодировка редактора (терминала) по умолчанию (при создании все файлы приводятся к этой кодировке)
if has('win32')
   set encoding=cp1251
else
   set encoding=utf-8
   set termencoding=utf-8
endif
" формат файла по умолчанию (влияет на окончания строк) - будет перебираться в указанном порядке
set fileformat=unix
" варианты кодировки файла по умолчанию (все файлы по умолчанию сохраняются в этой кодировке)
set fencs=utf-8,cp1251,koi8-r,cp866
"" Перед сохранением .vimrc обновлять дату последнего изменения
autocmd! bufwritepre $MYVIMRC call setline(1, '"" Last update: '.strftime("%d.%m.%Y %H:%M"))
syntax on " включить подсветку синтаксиса
"" Применять типы файлов
filetype on
filetype plugin on
filetype indent on
autocmd FileType perl call SetPerlConf()
"Удалять пустые пробелы на концах строк при открытии файла
autocmd BufEnter *.* :call RemoveTrailingSpaces()
"Путь для поиска файлов командами gf, [f, ]f, ^Wf, :find, :sfind, :tabfind и т.д.
"поиск начинается от директории текущего открытого файла, ищет в ней же
"и в поддиректориях. Пути для поиска перечисляются через запятую, например:
"set path=.,,**,/src,/usr/local
set path=.,,**


"НАСТРОЙКИ ОТСТУПА
set shiftwidth=4 " размер отступов (нажатие на << или >>)
set tabstop=4 " ширина табуляции
set softtabstop=4 " ширина 'мягкого' таба
set autoindent " ai - включить автоотступы (копируется отступ предыдущей строки)
set cindent " ci - отступы в стиле С
set expandtab " преобразовать табуляцию в пробелы
set smartindent " Умные отступы (например, автоотступ после {)
" Для указанных типов файлов отключает замену табов пробелами и меняет ширину отступа
au FileType crontab,fstab,make set noexpandtab tabstop=8 shiftwidth=8


"НАСТРОЙКИ ВНЕШНЕГО ВИДА
" Установка шрифта (для Windows и Linux)
" настройка внешнего вида для GUI
if has('gui')
    " отключаем графические табы (останутся текстовые,
    " занимают меньше места на экране)
    set guioptions-=e
    " отключить показ иконок в окне GUI (файл, сохранить и т.д.)
    set guioptions-=T

    if has('win32')
        set guifont=Lucida_Console:h10:cRUSSIAN::
    else
        set guifont=Terminus\ 10
    endif
endif


"НАСТРОЙКИ ПЕРЕКЛЮЧЕНИЯ РАСКЛАДОК КЛАВИАТУРЫ
"" Взято у konishchevdmitry
set keymap=russian-jcukenwin " настраиваем переключение раскладок клавиатуры по 
set iminsert=0 " раскладка по умолчанию - английская
set imsearch=0 " аналогично для строки поиска и ввода команд
function! MyKeyMapHighlight()
   if &iminsert == 0 " при английской раскладке статусная строка текущего окна будет серого цвета
      hi StatusLine ctermfg=White guifg=White
   else " а при русской - зеленого.
      hi StatusLine ctermfg=DarkRed guifg=DarkRed
   endif
endfunction
call MyKeyMapHighlight() " при старте Vim устанавливать цвет статусной строки
autocmd WinEnter * :call MyKeyMapHighlight() " при смене окна обновлять информацию о раскладках
" использовать Ctrl+F для переключения раскладок
cmap   
imap   X:call MyKeyMapHighlight()a
nmap   a:call MyKeyMapHighlight()
vmap   a:call MyKeyMapHighlight()gv


"ВКЛЮЧЕНИЕ АВТОДОПЛНЕНИЯ ВВОДА (omnifunct)
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType tt2html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
" Опции автодополнения - включаем только меню с доступными вариантами
" автодополнения (также, например, для omni completion может быть
" окно предварительного просмотра).
set completeopt=menu
"-------------------------------------------------------------------------------
" perl-support.vim
"-------------------------------------------------------------------------------
let g:Perl_AuthorName        = 'dimio'
let g:Perl_AuthorRef         = 'http:://dimio.org'
let g:Perl_Email             = 'dimio@dimio.org'


"НАСТРОЙКИ ГОРЯЧИХ КЛАВИШ
" F2 - сохранить файл
nmap  :w
vmap  :wi
imap  :wi
" F3 - рекурсивный поиск по файлам (плагин grep.vim)
nnoremap   :Rgrep
" Shift-F - добавление найденного к прошлым результатам поиска
nnoremap  > :RgrepAdd
" Ctrl-F - поиск в открытых буферах
nnoremap  > :GrepBuffer
" F5 - просмотр списка буферов
nmap  :buffers
vmap  :buffers
imap  :buffersa
" при включенном плагине можно использовать его
nmap  :BufExplorer
" F6 - предыдущий буфер
map  :bp
vmap  :bpi
imap  :bpi
" F7 - следующий буфер
map  :bn
vmap  :bni
imap  :bni
" F9 - сохранение файла и запуск компиляции (make)
map  :w:make
vmap  :w:makei
imap  :w:makei
" F10 - включить-выключить браузер структуры документа (TagList)
map  :TlistToggle
vmap  :TlistToggle
imap  :TlistToggle
" F11 - включить-выключить нумерацию строк
imap  :setnu!a
nmap  :setnu!
" F12 - обозреватель файлов (:Ex для стандартного обозревателя,
" плагин NERDTree - дерево каталогов)
map  :NERDTreeToggle
vmap  :NERDTreeTogglei
imap  :NERDTreeTogglei
"" Переключение табов (вкладок) (rxvt-style)
map  :tabprevious
nmap  :tabprevious
imap  :tabpreviousi
map  :tabnext
nmap  :tabnext
imap  :tabnexti
nmap  :tabnew
imap  :tabnew
nmap  :tabnew
imap  :tabnew
nmap  :tabclose
imap  :tabclose


"" Переключение кодировок файла
   " Меню Encoding -->
        " Выбор кодировки, в которой читать файл -->
            set wildmenu
            set wcm=
            menu Encoding.Read.utf-8 :e ++enc=utf8 
            menu Encoding.Read.windows-1251 :e ++enc=cp1251
            menu Encoding.Read.koi8-r :e ++enc=koi8-r
            menu Encoding.Read.cp866 :e ++enc=cp866
            map  :emenu Encoding.Read.
        " Выбор кодировки, в которой читать файл <--

        " Выбор кодировки, в которой сохранять файл -->
            set wildmenu
            set wcm=
            menu Encoding.Write.utf-8 :set fenc=utf8 
            menu Encoding.Write.windows-1251 :set fenc=cp1251
            menu Encoding.Write.koi8-r :set fenc=koi8-r
            menu Encoding.Write.cp866 :set fenc=cp866
            map  :emenu Encoding.Write.
        " Выбор кодировки, в которой сохранять файл <--

        " Выбор формата концов строк (dos - , unix - , mac - ) -->
            set wildmenu
            set wcm=
            menu Encoding.End_line_format.unix :set fileformat=unix
            menu Encoding.End_line_format.dos :set fileformat=dos
            menu Encoding.End_line_format.mac :set fileformat=mac
            map  :emenu Encoding.End_line_format.
        " Выбор формата концов строк (dos - , unix - , mac - ) <--
    " Меню Encoding <--

    " Включение автоматического разбиения строки на несколько
    " строк фиксированной длины
    menu Textwidth.off :set textwidth=0
    menu Textwidth.on :set textwidth=78
    " Проверка орфографии -->
        if version >= 700
            " По умолчанию проверка орфографии выключена.
            set spell spelllang=
            set nospell
            menu Spell.off :setlocal spell spelllang=:setlocal nospell
            menu Spell.Russian+English :setlocal spell spelllang=ru,en
            menu Spell.Russian :setlocal spell spelllang=ru
            menu Spell.English :setlocal spell spelllang=en
            menu Spell.-SpellControl- :
            menu Spell.Word\ Suggestz= z=
            menu Spell.Add\ To\ Dictionaryzg zg
            menu Spell.Add\ To\ TemporaryDictionaryzG zG
            menu Spell.Remove\ From\ Dictionaryzw zw
            menu Spell.Remove\ From\ Temporary\ DictionaryzW zW
            menu Spell.Previous\ Wrong\ Word[s [s
            menu Spell.Next\ Wrong\ Word]s ]s
        endif
    " Проверка орфографии <--

        " Обертка для :make -->
        nmap ,m :call make
        nmap ,w :cwindow
        nmap ,n :cnext
        nmap ,p :cprevious
        nmap ,l :clist

        menu Make.Make,m ,m
        menu Make.Make\ Window,w ,w
        menu Make.Next\ Error,n ,n
        menu Make.Previous\ Error,p ,p
        menu Make.Errors\ List,l ,l
    " Обертка для :make <--

    " Обновление ctags -->
        function! MyUpdateCtags()
            echo "Update ctags function is not setted."
        endfunction
        let MyUpdateCtagsFunction = "MyUpdateCtags"
        nmap  :call {MyUpdateCtagsFunction}()
        menu ctags.Update 
    " Обновление ctags <--

" C(trl)+d - дублирование текущей строки
imap  yypi
" Ctrl-пробел для автодополнения
inoremap  
" C-e - комментировать/раскомментировать (при помощи NERD_Comment)
map  ,ci
nmap  ,ci
imap  ,cii
"" Вырезать-копировать-вставить через Ctrl
" CTRL-X - вырезать
vnoremap  "+x
" CTRL-C - копировать
vnoremap  "+y
" CTRL-V вставить под курсором
map       "+gP
"" Отменить-вернуть через Ctrl
" отмена действия
noremap  u
inoremap  u
" вернуть отменённое назад
noremap  
inoremap  


"ФУНКЦИИ (не вошедшие в состав других разделов)
" Применение дополнительных настроек при открытии perl-файла
" При открытии файла задавать для него соответствующий 'компилятор'
" и настроечный файл для IDE.
" Установить метод свертки блоков кода по отступам
function! SetPerlConf()
    compiler perl
    "" source "$VIMRUNTIME/IDE/perl-ide.vim"
    set foldmethod=indent
    " настройка плагина подсветки синтаксиса для Mojolicious
    " github.com/yko/mojo.vim
    " подсвечивать perl-код в секции __DATA__ perl-файлов
    let mojo_highlight_data = 1
endfunction

"" Поиск выделенного текста (frantsev.ru/configs/vimrc.txt)
function! VisualSearch()
   let l:old_reg=getreg('"')
   let l:old_regtype=getregtype('"')
   normal! gvy
   let @/=escape(@@, '$.*/\[]')
   normal! gV
   call setreg('"', l:old_reg, l:old_regtype)
endfunction

"" Удалить пробелы в конце строк (frantsev)
function! RemoveTrailingSpaces()
   normal! mzHmy
   execute '%s:\s\+$::ge'
   normal! 'yzt`z
endfunction

"" Сохранять умные резервные копии ежедневно
function! BackupDir()
   " определим каталог для сохранения резервной копии
   if has('win32')
        let l:backupdir = $TEMP.'\backup'
    else
        let l:backupdir = $VIMRUNTIME.'/backup/'.
        \substitute(expand('%:p:h'), '^'.$HOME, '~', '')
    endif
   " если каталог не существует, создадим его рекурсивно
   if !isdirectory(l:backupdir)
      call mkdir(l:backupdir, 'p', 0700)
   endif
   " переопределим каталог для резервных копий
   let &backupdir=l:backupdir
   " переопределим расширение файла резервной копии
   let &backupext=strftime('~%Y-%m-%d~')
endfunction