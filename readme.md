# VIC 20 Dead Test Cartridge/Kernal

A dead test cartridge and kernal for the Commodore VIC-20, designed to test the hardware of the machine. It checks the lower RAM, video RAM, expansion RAM, and ROMs for faults.

It can be deployed as a cartridge or as a replacement for the kernal ROM.

The cartridge version is less invasive to install, and automatically detects if the machine is PAL or NTSC and set the video modes accordingly.  However, the cartridge version is launched by the kernal, and relies on the system having working stack RAM.

The kernal version does not relies on working stack RAM to launch, as it runs in place of the stock kernal, and does not use the stack until the first 1KB of lower memory has been successfully tested.  Hence, if the cartridge version fails to launch, you can try the kernal version instead.  You must install the correct PAL or NTSC kernal ROM for the machine, as, when running as a kernal ROM, the code cannot not detect this automatically.

## Build instructions

Install xa65

```bash
git clone https://github.com/fachat/xa65
cd xa65/xa
make  # Produces `xa` binary in the current directory
```

Then clone and build the dead test cartridge

```bash
cd ~  # Set current directory as required
git clone https://github.com/piersfinlayson/Vic20-dead-test.git
cd Vic20-dead-test
XA65=/path/to/xa65 make all
```

This creates 3 version of the dead test program:

- `build/dead-test.a0` (original cartridge version)
- `build/dead-test.crt` (VICE cartridge version)
- `build/dead-test.pal.e0` (PAL KERNAL version)
- `build/dead-test.ntsc.e0` (NTSC KERNAL version)

## Usage

The compiled binary (`build/dead-test.a0`) can be loaded to a cartridge at address $A000.

Alternatively, you can replace your kernal ROM with one of:

- `build/dead-test.pal.e0` (PAL KERNAL version)
- `build/dead-test.ntsc.e0` (NTSC KERNAL version)

When using the cartridge version, powering on the program will detect if you are using PAL or NTSC and set the appropriate video modes.  If using the kernal replacement, you will need to install the correct PAL or NTSC kernal ROM.

Tests will then be run on the lower RAM, followed by video RAM.

- Lower RAM $0000-$03FF
- Video RAM $9400-$97FF

If there is a fault found with any of these tests the code will display the error and also show the chip number.

Following this the following RAM is tested:

- BLK1,2,3 RAM from expansion cartridges
- 1Kb Expansion $0400-$07FF - RAM1
- 1Kb Expansion $0800-$0BFF - RAM2
- 1Kb Expansion $0C00-$0FFF - RAM1
- Main RAM address $1000-$13FF (1Kb)  - RAMa
- Main RAM address $1400-$17FF (1Kb)  - RAMb
- Main RAM address $1800-$1BFF (1Kb)  - RAMc
- Main RAM address $1C00-$1FFF (1Kb)  - RAMd

On each 1Kb of RAM the upper and lower nibble of data is checked, followed by address and data lines. If the test fails on the nibble then data/address lines will not be tested and the code will then move onto the next block.

On each failure the status screen will also be updated with the chip number that is faulty.

Following these tests the CRC value is calculated for each ROM (Basic, Char, Kernal) and if a matching version is found the status page will be updated.  If the dead-test ROM is install as the kernal ROM, that will be indicated, although the dead-test ROM checksum will not be checked - as it is difficult to pre-compute the ROM's eventual checksum during the build process.

The code currently checks for

- 901460-02
- 901460-03
- 901486-01
- 901486-02
- 901486-06
- 901486-07
- JiffyDOS PAL KERNAL
- JiffyDOS NTSC KERNAL

## Interpreting the output

When testing the main RAM, its broken down into 4 tests

- Upper nibble
- Lower nibble
- Address lines
- Data lines

On the below screenshot the lower RAM test fails and no further tests are performed.

![Lower RAM test](https://github.com/StormTrooper/Vic20-dead-test/blob/master/images/fail-lower.png?raw=true)

On the below screenshot:

- Upper nibble from RAMa (1000-$13FF) passes
- Lower nibble from RAMa (1000-$13FF) fails with chip reference shown
- ROM versions are calculated with CRC and shown

![RAM Fail](https://github.com/StormTrooper/Vic20-dead-test/blob/master/images/fail2.png?raw=true)

On the below screenshot:

- Upper nibble from RAMa (1000-$13FF) passes
- Lower nibble from RAMa (1000-$13FF) fails with chip reference shown
- Upper nibble from RAMc (1800-$1BFF) fails with chip reference shown
- Lower nibble from RAMc (1800-$1BFF) fails with chip reference shown

![RAM Fail](https://github.com/StormTrooper/Vic20-dead-test/blob/master/images/fail1.png?raw=true)

On the below screenshot all tests pass.

![RAM Pass](https://github.com/StormTrooper/Vic20-dead-test/blob/master/images/pass.png?raw=true)

## Acknowledgements

Original version was written by [Simon Rowe](https://eden.mose.org.uk/gitweb/?p=dead-test.git;a=summary).

Enhancements and modifications by [Greg McCarthy](htps://github.com/StormTrooper/Vic20-dead-test):

- NTSC/PAL check
- Display chip information
- Change formatting of screen
- Loading of screen before any checks have been done

Further enhancements by [Piers Finlayson](piers@piers.rocks):

- Added kernal ROM version
- Added Makefile for easy building

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.
