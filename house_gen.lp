
#const max_width=12.
#const max_height=10.

construction_type(door;wall;floor;bed).
terrain_type(grass;flower;bridge;water;tree)

width(1..max_width).
height(1..max_height).

1 {terrain(XX,YY,TERRAIN_TYPE) : terrain_type(TERRAIN_TYPE)} 1 :- 
	width(XX), 
	height(YY).

0 {construction(XX, YY, CONSTRUCTION_TYPE) : construction_type(CONSTRUCTION_TYPE)} 1 :-
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
	
immediate_neighbors(XX,YY,TYPE, COUNT) :- 
	COUNT =  {construction(XX,YY-1,TYPE);
					construction(XX-1,YY,TYPE);
					construction(XX+1,YY,TYPE);
					construction(XX,YY+1,TYPE)},
					construction(XX,YY,_),					
					construction_type(TYPE).

good_land(XX,YY) :- 
	terrain(XX,YY, TYPE), TYPE != water, TYPE != bridge, TYPE != tree

:- construction(XX, YY, _), not good_land(XX,YY).                              

