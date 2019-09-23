# Heron
All documents about Heron
-  Documentment

  Official documentation.
- Ros 

  Ros packages impliments on Heron. 

### Basic Command
(1) Connect with Heron: <br>
First use your pc to connect the WIFI from Heron. <br>
Then open the terminal and run: <br>
```c
$ ssh administrator@192.168.1.1
```

(2) Check available topics or nodes: <br>
```c
$ rostopic list
$ rosnode list
```

(3) Echo particular topic: <br>
```c
$ rostopic echo LIST_YOU_NEED
```

(4) Kill node on Heron: <br>
```c
$ rosnode kill NODE_NEED_KILL
```

(5) Record bag file: <br>
```c
$ rosbag record -a
```
