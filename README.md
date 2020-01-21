# Sun Clock

Flutter solar clock for [Flutter Clock Face Challenge](https://flutter.dev/clock)

Displays the solar time and hour angle (and local time), and displays the sun position based on the user's longitude.
It has a light theme and a dark theme, and displays sample weather and location data that comes from the device.

## Screenshot

![image](https://user-images.githubusercontent.com/6836149/73172922-e828dc80-40e2-11ea-8c95-9263d15ded36.png)
![image](https://user-images.githubusercontent.com/6836149/73173033-29b98780-40e3-11ea-9b3e-bad6db694911.png)

## Components

**Analog clock** 
![image](https://user-images.githubusercontent.com/6836149/73172173-2cb37880-40e1-11ea-954a-a1063e75e8e7.png)
Shows the analog local time. In this case, **08:44:01 AM**.

**Solar time**
![image](https://user-images.githubusercontent.com/6836149/73172308-77cd8b80-40e1-11ea-821b-74da00444800.png)
Shows the LST (Local solar time). Shown with a yellow handle. In this case, **06:47:10 AM** 

**Solar position**
![image](https://user-images.githubusercontent.com/6836149/73172540-03dfb300-40e2-11ea-981b-5dfef1ed3645.png)
Shows the position of the sun according to its HA (Hour Angle). Shown with a small orange circle. In this case, `-77º` (0 is noon)

**Sunrise time**
![image](https://user-images.githubusercontent.com/6836149/73172731-76509300-40e2-11ea-9aef-b67a08b119f9.png)
Time of sunrise in local area. Shown with a blue hand. In this case, **7:03:00 AM**

**Sunset time**
![image](https://user-images.githubusercontent.com/6836149/73172814-9f712380-40e2-11ea-9465-2e421594784f.png)
Time of sunset in local area. Shown with an orange handle. In this case, **8:55:00 PM**

**Solar noon*
![image](https://user-images.githubusercontent.com/6836149/73172854-b9ab0180-40e2-11ea-9531-60dffac7fcc3.png)
Time of solar noon (sun highest in the sky) for local area. In this case, **1:58:00 PM** 


**Important**

Uses the user's location so permissions need to be handled. Follow the [geolocator plugin instructions](https://pub.dev/packages/geolocator#permissions) to add them.