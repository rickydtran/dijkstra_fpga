# Optimization of Dijkstra's Shortest Path Algorithm on FPGA
[CLICK TO SEE PROJECT SPECIFICATIONS](http://rickytran.com:8000/f/fd1c01e620/?dl=1)  

# Table of Contents
[Group Members](#team-members)  
[Things to Do](#todo)  
[Project Description](#description)  

# <a name="group-members"></a>Group Members
* "Ricky Tran" <rickydtran@ufl.edu>
* "Christopher Lai" <chrislai95@ufl.edu>
* "Wyndham Hudson" <caelum@ufl.edu>

# <a name="todo"></a>TODO:
* ~~Stop Short Path Algorithm when destination is reached. Right now it computes incantations to all realms. Source to all destination~~
* ~~REVISION: Don't need path anymore. Compute gems necessary in realtime with Short Path Alg.~~  ~~Store pathway from source to destination from from Short Path Algorithm~~ 
* Implement Heap to Lower Time Complexity of Short Path Algorithm
* ~~REVISION: Subsequence gets it's own array. Also modified function 
with a binary search to increase performance.~~ ~~Modify find max 
subsequence 
function to actually 
return 
the 
subsequence~~
* ~~Use hash map for string lookup pointer retrieval. Reduces lookup from O(n) to constant time~~

# <a name="descritpion"></a>Project Description
Dijkstra’s shortest path algorithm is one of the most important algorithms available for generating the exact optimal solutions to a large set of shortest path problems. Dijkstra’s is a greedy algorithm that provides a solution to several real world problems, such as traversing road, router, and telephone networks. Optimizing Dijkstra’s algorithm would improve performance in the world of navigation and communication. 

The algorithm works by visiting neighboring vertices of a graph beginning at a starting point. It then repeatedly examines the closest not-yet-examined vertex, adding its vertices to the set of vertices already examined. It then expands outwards from the initial starting point until it reaches its end point. The algorithm revolves around edge relaxation, where the shortest known path between two vertices can be extended by adding the edge coordinates at the end.