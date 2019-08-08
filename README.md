# Conversion-model-Motion2GVS
This program computes the GVS current profile needed to generate the similar perception to the physical rotational velocity profile defined by the user. It is assumed that the person is sitting with their head peached 72.7 degrees downward (this angle is computed using the orientation of human semicircular canals measured by three-dimensional multiplanar CT reconstruction, Della Santina et al. 2005). The physical velocity profile is consisted of three parts: an ascending ramp starting at 0 degrees/sec, a constant velocity segment, and a descending ramp with an acceleration same as the ascending ramp in absolute value. The user defines the ramp acceleration (a), ramp duration (d), and the constant velocity duration (t) as the function inputs. The function will plot the motion velocity profile (top panel) and the computed equivalent GVS current profile (bottom panel). The function returns a discretized GVS current profile over time with 0.1-second time steps.
Usage Examples,
1- To plot the motion and the equivalent GVS current profiles.
When,
the ramp acceleration is: 10 m/sec^2 >>> a=10 
the ramp duration is: 1 second >>>> d=1
the constant velocity duration is: 60 sec >>> t=60
Mo2GVS(10,1,60);
2- To plot the motion and the equivalent GVS current profiles as well as storing the discretized GVS current profile: 
When,
the ramp acceleration is: 10 m/sec^2 >>> a=10 
the ramp duration is: 1 second >>>> d=1
the constant velocity duration is: 60 sec >>> t=60
EVS=Mo2GVS(10,1,60);
