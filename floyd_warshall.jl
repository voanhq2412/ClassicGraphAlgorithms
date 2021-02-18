# using XLSX
# import Missings
# xl = XLSX.readxlsx("D:\\O.R\\Julia Script\\cases.xlsx")
# matrix = xl["Sheet1"]["B17:J25"]
#
# nrow = size(matrix,1)
# replace!(matrix, missing=>Inf)
#


function fw_sp(matrix)
    for i = 1:nrow
        for j = 1:nrow
            for k = 1:nrow
                if j == k
                    matrix[j,k]=0
                else
                    d = matrix[j,i] + matrix[i,k]
                    if d < matrix[j,k]
                        # println("i = $i, j = $j, k = $k")
                        matrix[j,k] = d
                        # println("after = ", d, "\n")
                    end
                end
            end
        end
    end
    return matrix
end

# matrix = fw_sp(matrix)
#
# for i=1:nrow
#     println(matrix[i,:])
# end
