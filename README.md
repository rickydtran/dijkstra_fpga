# Optimization of Dijkstra's Shortest Path Algorithm on FPGA
[CLICK TO SEE PROJECT SPECIFICATIONS](https://github.com/rickydtran/dijkstra_fpga/blob/master/doc/RC-Project-Proposal.pdf)  

# Table of Contents
[Group Members](#team-members)  
[Things to Do](#todo)
[How to](#guide)
[Project Description](#description)  

# <a name="group-members"></a>Group Members
* "Ricky Tran" <rickydtran@ufl.edu>
* "Christopher Lai" <chrislai95@ufl.edu>
* "Wyndham Hudson" <caelum@ufl.edu>

# <a name="todo"></a>TODO:
* ~~Created Makefile for Environment for project~~
* ~~Implemented Graph Object~~
* ~~Created Graph Object functions (ie. add edges, num of edges, size, etc.)~~
* ~~Created Spanning Tree to have all nodes connected~~
* ~~Random Graph Data generation based off of P factor b/w 0.1 and 0.9~~
* ~~Setup testcases for Graph Object~~
* ~~Create SW Implementation of Dijkstra's for adj matrix~~
* ~~Create SW Implementation of Dijkstra's for adj list and heap(pqueue)~~
* ~~Port fibbanacci heap into wrapper to use with adj list~~
* ~~Brainstorm HW implementation and Optimizations~~
* Create HW Implmenetation of Dijkstra's
* ~~Do performance metrics of SW Implmentation~~
* Do performance metrics of HW Implemenation

# <a name="guide"></a>How to:
[CLICK FOR GIT DUMMY GUIDE](https://rogerdudler.github.io/git-guide/)
1. git clone https://github.com/rickydtran/dijkstra_fpga.git (only done initially, do git pull origin master to get latest changes after)
2. Enter github credentials
3. git checkout -b branchname
4. Do shit
5. git add -A
6. git commit -m "blah"
7. git push origin branchname

# <a name="descritpion"></a>Project Description
Dijkstra’s shortest path algorithm is one of the most important algorithms available for generating the exact optimal solutions to a large set of shortest path problems. Dijkstra’s is a greedy algorithm that provides a solution to several real world problems, such as traversing road, router, and telephone networks. Optimizing Dijkstra’s algorithm would improve performance in the world of navigation and communication. 

The algorithm works by visiting neighboring vertices of a graph beginning at a starting point. It then repeatedly examines the closest not-yet-examined vertex, adding its vertices to the set of vertices already examined. It then expands outwards from the initial starting point until it reaches its end point. The algorithm revolves around edge relaxation, where the shortest known path between two vertices can be extended by adding the edge coordinates at the end.
