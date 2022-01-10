
SphereRadius=2;
OverAngle=27;
InnerRadius = 48;
MainRadius=InnerRadius+7;
LipWidth=2.5;
HolderHeight=25;
LipHeight=4;
PodBottomDiameter=23;
PodTopDiameter=30;
PodHeight=22;

module sequentialHull(){
    echo($children);
    for (i = [0: $children-2])
        hull(){
            children(i);
            children(i+1);
        }
}


module OutlinePoly(r=30,numPoints=60,anglemin=0,anglemax=180)
{
    step = (anglemax-anglemin)/numPoints;
    polypoints=[ for(a=[anglemin:step:anglemax]) [r*cos(a),r*sin(a)] ];
    polygon(points=polypoints);
}


module MainBody()
{
    linear_extrude(height=HolderHeight)
    {
        OutlinePoly(r=MainRadius,anglemin=-OverAngle,anglemax=180+OverAngle);
    }
    translate([0,0,-LipHeight])
    linear_extrude(height=LipHeight)
    {
        difference()
        {
            OutlinePoly(r=InnerRadius,anglemin=-OverAngle,anglemax=180+OverAngle);
            OutlinePoly(r=InnerRadius-LipWidth,anglemin=-OverAngle,anglemax=180+OverAngle);
        }
    }
}

module Pod()
{
    hull()
    {
        linear_extrude(height=0.1) circle(d=PodBottomDiameter);
        translate([0,0,PodHeight])  linear_extrude(height=0.1) circle(d=PodTopDiameter);
    }
}

module PaperTray()
{
    Height = HolderHeight*1.5;
    HalfHeight=Height/2;

    translate([MainRadius-6,-25,0])
    {
        difference()
        {
            union()
            {
                cube([20,40,HolderHeight]);
                translate([5.5,0,0]) cube([15,MainRadius*1.8,HolderHeight*1.5]);
            }
            translate([10.5,0,3]) cube([5,MainRadius*2,100]);
        }
    }
}

module PodHoles()
{
    translate([0,-4,3]) Pod();
    translate([36,-4,3]) Pod();
    translate([-36,-4,3]) Pod();
    translate([18,30,3]) Pod();
    translate([-18,30,3]) Pod();
}

difference()
{
    union()
    {
        MainBody();
        PaperTray();
    }
    translate([-1,-2,0]) PodHoles();
}