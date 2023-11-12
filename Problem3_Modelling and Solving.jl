using JuMP, GLPK, XLSX, Gurobi

nb_city = 13;
c = XLSX.readdata("FRANCE.xlsx", "Feuil1", "B3:N15");
cities = XLSX.readdata("FRANCE.xlsx", "Feuil1", "A3:A15");

model = Model(GLPK.Optimizer);

# Variables
@variable(model, x[1:nb_city, 1:nb_city], Bin);
relax_integrality(model)

# Objective function
@objective(model, Min, sum(sum(x[i, j]*c[i, j] for j in 1:nb_city) for i in 1:nb_city));

# Constraints
for i in 1:nb_city
    @constraint(model, sum(x[i, j] for j in 1:nb_city) == 1)
end
for j in 1:nb_city
    @constraint(model, sum(x[i, j] for i in 1:nb_city) == 1)
end

# Solving
optimize!(model)

# Solution
print(objective_value(model))
JuMP.value.(x)
#2787.0 vs matrix

#13×13 Matrix{Float64}:
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0
 0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0
 0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0

# Add a constraint for the cycle Brest, Rennes, Nantes
@constraint(model, x[11, 2] + x[2, 11] + x[8, 11] + x[11, 8] + x[2, 8] + x[8, 2] <= 2);
@constraint(model, x[11, 2] + x[2, 11] <= 1);
@constraint(model, x[8, 2] + x[2, 8] <= 1);
@constraint(model, x[11, 8] + x[8, 11] <= 1);

# New solution 1
optimize!(model)
print(objective_value(model))
JuMP.value.(x)

#3351.0
#13×13 Matrix{Float64}:
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0
 0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0
 0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0

# Add new constraints
@constraint(model, x[4, 6] + x[6, 4] <= 1);
@constraint(model, x[1, 13] + x[13, 1] <= 1);
@constraint(model, x[12, 3] + x[3, 12] <= 1);
@constraint(model, x[7, 9] + x[9, 7] <= 1);

# New solution 2
optimize!(model)
print(objective_value(model))
JuMP.value.(x)

#3686.0
#13×13 Matrix{Float64}:
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0
 0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0
 0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0
 0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
 1.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0

##MTZ constraint

model2 = Model(GLPK.Optimizer);

@variable(model2, x[1:nb_city, 1:nb_city], Bin);
@objective(model2, Min, sum(sum(x[i, j]*c[i, j] for j in 1:nb_city) for i in 1:nb_city));
relax_integrality(model2)

for i in 1:nb_city
    @constraint(model2, sum(x[i, j] for j in 1:nb_city) == 1)
end
for j in 1:nb_city
    @constraint(model2, sum(x[i, j] for i in 1:nb_city) == 1)
end

# Solving
optimize!(model2)

# Adding MTZ constraints
@variable(model2, 2 <= u[i=2:nb_city] <= nb_city)
for i in 2:nb_city
    for j in 2:nb_city
        if i != j
            @constraint(model2, u[j]-u[i] >= 1 - (nb_city-1)*(1-x[i, j]))
        end
    end
end

# With the new term
@variable(model2, 2 <= u[i=2:nb_city] <= nb_city)
for i in 2:nb_city
    for j in 2:nb_city
        if i != j
            @constraint(model2, u[j]-u[i] >= 2 - nb_city + (nb_city-1)*x[i, j] + (nb_city-3)*x[j, i])
        end
    end
end

# Strenghten with a constrainst
for j in 2:nb_city
    @constraint(model2, u[j] <= nb_city-1 + (3-nb_city)*x[1, j] + x[j, 1])
    @constraint(model2, u[j] >= 3 - x[1, j] + (nb_city-3)*x[j, 1])
end

optimize!(model2)
print(objective_value(model2))
JuMP.value.(x)
# Even better ! 3395, lower bound improved
