using XLSX
using DataStructures
import Missings

xl = XLSX.readxlsx("D:\\O.R\\Julia Script\\cases.xlsx")
capacity = xl["Sheet1"]["B31:J39"]
capacity = coalesce.(capacity, 0)
nrow = size(capacity,1)

cost = xl["Sheet1"]["B17:J25"]
coalesce.(cost, 0)

balance =  xl["Sheet1"]["B43:J43"]
println(balance)
flow =  zeros(Int8,nrow , nrow)







function sp_dj(cost,capacity,from)
    pq = PriorityQueue()
    # start node, end node

    nrow = size(cost,1)
    visited = [0 for i in 1:nrow]
    distance = [Inf for i in 1:nrow]
    distance[from] = 0
    pq[from]=0

    path = Dict()
    path[from] = [from]

    while (!isempty(pq))
        get = dequeue!(pq)
        visited[get] = 1


        for i = 1:nrow
            p = copy(path[get])
            if capacity[get,i]>0 && visited[i]==0
                d = distance[get]+cost[get,i]
                if distance[i]>d
                    pq[i] = d
                    distance[i] = d

                    new = append!(p,i)
                    path[i] = new
                end
            end
        end
    end
    return path,distance
end




global start = 1
while (count(x->x==0,balance)!=length(balance))

    # Remaining Capacity
    rem_cap = capacity - flow

    # Pick supply node
    global start
    if balance[start] > 0
        dj = sp_dj(cost,rem_cap,start)
        println(dj)
        paths = dj[1]
        distance = dj[2]
    else
        start+=1
        continue
    end


    # Pick Demand node, closest nodes first
    pq = PriorityQueue()
    for i = 1:nrow
        if (balance[i]<0)
            pq[i] = distance[i]
        end
    end

    update_flow = []
    while balance[start]!=0
        println(pq)
        to = dequeue!(pq)

        # max_flow
        min = Inf
        path = paths[to]
        for i=1:(length(path)-1)
            if rem_cap[path[i],path[i+1]]<min
                min = rem_cap[path[i],path[i+1]]
            end
        end

        # Update Flow
        for i=1:(length(path)-1)
            flow[path[i],path[i+1]] = flow[path[i],path[i+1]] + min
            flow[path[i+1],path[i]] = flow[path[i+1],path[i]] + min
        end


        balance[to] = balance[to] + min
        balance[start] = balance[start] - min
        println("$start sends $min to $to through path $path")
        println("balance = $balance")
    end

    println("Next supply node...\n")

end
