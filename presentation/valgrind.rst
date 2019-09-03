
:: 
    valgrind -q --tool=memcheck --leak-check=yes <executable>

::
    time valgrind --tool=callgrind ./slow
    callgrind_annotate --auto=yes --inclusive=yes > slow.callgrind
