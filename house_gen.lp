
#const max_width=12.
#const max_height=10.

construction_type(door;wall;floor;bed).
terrain_type(grass;flower;bridge;water;tree).

width(1..max_width).
height(1..max_height).

1 {terrain(XX,YY,TERRAIN_TYPE) : terrain_type(TERRAIN_TYPE)} 1 :- 
	width(XX), 
	height(YY).

0 {construction(XX,YY,CONSTRUCTION_TYPE) : construction_type(CONSTRUCTION_TYPE)} 1 :-
	width(XX),
	height(YY).

% Your house should contain at least 1 door, 1 bed, all non-bed tiles should be floor, and the perimeter of the house should be walls
	
neighbors(XX,YY,TYPE, COUNT) :- 
	COUNT =  {construction(XX-1,YY-1,TYPE);
					construction(XX,YY-1,TYPE);
					construction(XX+1,YY-1,TYPE);
					construction(XX-1,YY,TYPE);
					construction(XX+1,YY,TYPE);
					construction(XX-1,YY+1,TYPE);	
					construction(XX,YY+1,TYPE);
					construction(XX+1,YY+1,TYPE)},
					construction(XX,YY,_),					
					construction_type(TYPE).		

terrain_neighbors(XX,YY,TYPE, COUNT) :- 
	COUNT =  {terrain(XX-1,YY-1,TYPE);
					terrain(XX,YY-1,TYPE);
					terrain(XX+1,YY-1,TYPE);
					terrain(XX-1,YY,TYPE);
					terrain(XX+1,YY,TYPE);
					terrain(XX-1,YY+1,TYPE);	
					terrain(XX,YY+1,TYPE);
					terrain(XX+1,YY+1,TYPE)},
					terrain(XX,YY,_),					
					terrain_type(TYPE).	
	
terrain_immediate_neighbors(XX,YY,TYPE, COUNT) :- 
	COUNT =  {construction(XX,YY-1,TYPE);
					construction(XX-1,YY,TYPE);
					construction(XX+1,YY,TYPE);
					construction(XX,YY+1,TYPE)},
					construction(XX,YY,_),					
					construction_type(TYPE).


good_land(XX,YY) :- 
	terrain(XX,YY,TYPE), TYPE != water, TYPE != bridge, TYPE != tree. 

edge(XX,YY) :- terrain_neighbors(XX,YY, _, E_COUNT), E_COUNT < 6.
corner(XX,YY) :- terrain_neighbors(XX,YY, _, C_COUNT), C_COUNT < 3.

:- construction(XX,YY, bed), not edge(XX,YY).
:- construction(XX,YY, bed), neighbors(XX,YY, bed, COUNT), COUNT > 0.
:- construction(XX,YY, bed), terrain_neighbors(XX,YY, water, W_COUNT), W_COUNT > 0.
:- construction(XX,YY, bed), terrain_neighbors(XX,YY, bridge, B_COUNT), B_COUNT > 0.
:- construction(XX,YY, bed), terrain_neighbors(XX,YY, tree, T_COUNT), T_COUNT > 0.

:- construction(XX,YY, door), not corner(XX,YY).
construction(XX, YY, door) :- terrain_immediate_neighbors(XX,YY, grass, G_COUNT), G_COUNT > 0
construction(XX, YY, door) :- terrain_immediate_neighbors(XX,YY, flower, G_COUNT), F_COUNT > 0

:- construction(XX,YY,_), not good_land(XX,YY).     


