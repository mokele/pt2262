This is an Erlang implementation of the pt2262 encoding usable on a Raspberry-PI with pihwm installed. 
This is inspired by the Arduino code via Ray's DIY Electronics Hobby Projects http://rayshobby.net/?p=2427

To cycle the power on a pt2262 socket do the following, where 17 is my RF transmitter GPIO pin.

```
1> pie:gpio_init(17, output).
ok
2> pie:gpio_write(17, pt2262:encode(62805, 193)).
ok
3> pie:gpio_write(17, pt2262:encode(62805, 193)).
ok
```


If you've got your Signature and Cmds in binary atm do the following to find out the integer values,
where each bit is the left side of the BIT:1 in the Erlang binary notation.

```
1> <<Sig:16>> = <<1:1, 1:1, 1:1, 1:1, 0:1, 1:1, 0:1, 1:1, 0:1, 1:1, 0:1, 1:1, 0:1, 1:1, 0:1, 1:1>>.
<<"õU">>
2> Sig.
62805
3> <<Cmd:8>> = <<1:1, 1:1, 0:1, 0:1, 0:1, 0:1, 0:1, 1:1>>.
<<"Á">>
4> Cmd.
193
```
