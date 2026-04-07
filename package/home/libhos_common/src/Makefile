OBJS:=hos_uci.o
LIB_NAME:=libhos_common.so
all: $(OBJS)
	$(CC) -o $(LIB_NAME) $(OBJS) $(LIBS) -shared
%.o:%.c 
	@$(CC) -c -o $@ $< $(CFLAGS) -fPIC
clean:
	rm $(LIB_NAME) *.o
