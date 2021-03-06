# Cyclone IV FGPA Serial UART TX

Send text using UART TX on Cyclone IV EP4CE6E22C8N to COM port on Windows PC.

My CYCLONE IV EP4CE6E22C8N Board has 4 buttons. When either button is pressed, I have programmed it to send one of 4 different text strings through UART TX pin 114. 

My Windows 10 receives the text on COM3 and displays it in [Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).

## Example Output

![Example](putty_result.jpg)

## Cyclone IV Dev Board with UART TTL USB Cable Plugged into pin 114

![Pin Connected](pin_connected.jpg)

Note that the white wire is connecting pin 114 on the Cyclone IV to the RXD pin on my [USB to TTL Serial Cable](https://amzn.to/3r5YbnZ).

![Pin 144](pin114.jpg)

## Buttons on Cyclone IV Dev Board

When these buttons are pressed, it sends the binary out of the UART TX Pin 114 on the Cyclone IV.

![Buttons](buttons.jpg)

## Windows Device Manager

Windows 10 Device Manager showing the [USB to TTL Serial Cable](https://amzn.to/3r5YbnZ) is present on COM3.

![](device_com3.jpg)

## Connect Putty to COM3

Select `Serial` radio button and use `COM3` in `Serial line` if your device manager shows `COM3`. Otherwise use whatever COM number your USB TTL was assigned by your PC when you connected it. 

I have programmed this code example to send at 9600 BAUD rate so leave 9600 as your speed setting.

![Putty COM3](putty-com3.jpg)

Press the [OPEN] button on Putty and start pressing buttons on Cyclone IV Dev board.

![Result Again](putty_result_2.jpg)

## Device Settings

Device settings for my CYCLONE IV EP4CE6E22C8N Board in Quartus Prime Lite edition V21.1

![Device Settings](device.jpg)

## Pin Assignments

Assigned pins using Quartus Prime Lite edition V21.1

![Pin Assignments](pins.jpg)

## How does this work?

The CYCLONE IV clock at `PIN_23` is running at 50 Mhz. 

If there are bits to send, then 1 bit is sent per 5208 ticks of the clock.

`50000000 / 5208` results in bits being sent across the wire at 9600 BAUD rate.

Each letter takes 10 bits to send.

- `0` for the `START` bit,
- `8` bits for the ASCII character, but reversed
- `1` for the `STOP` bit.

E.g.,
ASCII letter **A** = `01000001`

When bits are reversed = `10000010`
add `START` and `STOP` bits are added to the front and back, then it becomes `0100000101`

If all code is running, installed and devices wired correctly, then sending `0100000101` one bit at at time at a rate of 9600 BAUD results in the character `A` being written on the Putty screen.

In my code example, depending on which button is pressed, it sends all the bytes required at the required BAUD rate to show one of 4 collections of characters on Putty.

1. `sean\r\n`
2. `was \r\n`
3. `ere \r\n`
4. `#12345\n`

## Is this a perfect solution?

It's whatever you want it to be.

Read the [license](LICENSE).
