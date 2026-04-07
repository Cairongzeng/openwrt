OBJS:=hos_user.o hos_netlink.o hos_ubus.o hos_stat.o hos_config.o hos_utils.o main.o  hos_app_filter.o hos_mac_filter.o hos_common.o hos_system.o hos_network.o check_main.o
EXEC:=hosd
all: $(OBJS)
	$(CC) -o $(EXEC) $(OBJS) $(LIBS)
clean:
	rm $(EXEC) *.o
