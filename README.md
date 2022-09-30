# VGA Car Parking Simulator

**Course:** Digital Systems Conception

**Academic Year:** 2019/20

**Semester:** 1st

**Grade:** 19 out of 20

**Technologies Used:** VHDL, FPGA

**Brief Description:** Implementation of a 2-story parking controller via Petri Nets and a VGA interface (to complement the visual design) using the available Spartan3 FPGA board and the IOPT-Tools software. The car park has 99 spaces available in total, with 2 entrances, 2 exits (1 entrance and 1 exit per floor) and 2 unidirectional ramps to connect the 2 floors. Able to calculate the current occupancy of each floor, enter a floor of a car already inside the car park (ramp) and even deal with unusual situations (use of a ramp in the opposite direction or reversing on the ramp, entry and exit).

---

### Petri Net

<details>

![PetriNet](https://user-images.githubusercontent.com/46992334/193144408-189590ab-f923-4981-abb4-823f4750bd44.png)

</details>

---

### Demo

<details>
 <summary>Car park start</summary>

![CarParkStart](https://user-images.githubusercontent.com/46992334/193144412-acbe1144-c648-4b19-810a-71a78352a8d9.jpg)

</details>

<details>
 <summary>Car park with 10 cars</summary>

![CarParkWith10Cars](https://user-images.githubusercontent.com/46992334/193144413-b127f5e1-bc2e-4715-92bd-3763788cb74f.jpg)

</details>

<details>
 <summary>Car park with concurrent actions</summary>

![CarParkWithConcurrentActions](https://user-images.githubusercontent.com/46992334/193144406-374036ce-451f-48fd-b739-c9c6a773a923.jpg)

</details>
