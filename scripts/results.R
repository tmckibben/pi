# R script for taking scaling csv data and
# producing a scatter plot

# Import data
serial.w = read.csv(file = "../data/serial-weak.csv", header = FALSE)
serial.s = read.csv(file = "../data/serial-strong.csv", header = FALSE)
openmp.w = read.csv(file = "../data/openmp-weak.csv", header = FALSE)
openmp.s = read.csv(file = "../data/openmp-strong.csv", header = FALSE)
hybrid.s = read.csv(file = "../data/hybrid-strong.csv", header = FALSE)
hybrid.w = read.csv(file = "../data/hybrid-weak.csv", header = FALSE)

# Create strong scaling data frame
strong = hybrid.s
strong[,5:7] = NA
strong[,5] = serial.s[,6]
strong[,6] = openmp.s[,6]
strong[,7] = hybrid.s[,6]

# Serial and openmp are meaningless
# once you expand beyond one core
# or one node respectively
strong[2:24,5] = NA
strong[13:24,6] = NA

# Label columns
colnames(strong) = c("Nodes", "Cores/Node", "Cores", "Rectangles", "Serial", "OpenMP", "Hybrid")

# Strong scaling plots
# --------------------
pdf("../results/strong-scaling.pdf")
# One node strong 
plot(x = strong$Cores[1], y = strong$Serial[1], type = "o", xlab = "Cores", ylab = "Time", main = "Strong Scaling (One Node)", ylim = range(strong$Serial[1], strong$OpenMP[1:12], strong$Hybrid), xlim = range(strong$Cores[1:12]))
lines(strong$Cores[1:12], strong$OpenMP[1:12], type = "o", col = "Blue")
lines(strong$Cores[1:12], strong$Hybrid[1:12], type = "o", col = "Red")
lines(strong$Cores[2:12], rep( strong[1,5], 11), type = "o", col = "Green")
legend("topright", c("Serial", "OpenMP", "Hybrid", "Serial Projection"), lty = c(1,1,1,1), col = c("Black", "Blue", "Red", "Green"))

# Two node strong
plot(x = strong$Cores[13:24], y = rep( strong[1,5], 12), type = "o", xlab = "Cores", ylab = "Time", main = "Strong Scaling (Two Nodes)", ylim = range(strong$Serial[1], strong$OpenMP[1:12], strong$Hybrid), xlim = range(strong$Cores[13:24]))
lines(strong$Cores[13:18], strong$OpenMP[seq(2, 12, 2)], type = "o", col = "Blue")
lines(strong$Cores[19:24], rep( strong$OpenMP[12], 6 ), type = "o", col = "Green")
lines(strong$Cores[13:24], strong$Hybrid[13:24], type = "o", col = "Red")
legend("topright", c("Serial Projection", "OpenMP Model", "OpenMP Projection", "Hybrid"), lty = c(1,1,1,1), col = c("Black", "Blue","Green", "Red"))
dev.off()

# Create weak scaling data from
weak = hybrid.w
weak[,5:7] = NA
weak[,5] = serial.w[,6]
weak[,6] = openmp.w[,6]
weak[,7] = hybrid.w[,6]

# Serial and openmp are meaningless
# once you expand beyond one core
# or one node respectively
weak[5:24,5] = NA
weak[13:24,6] = NA

# Label columns
colnames(weak) = c("Nodes", "Cores/Node", "Cores", "Rectangles", "Serial", "OpenMP", "Hybrid")

# Weak scaling plots
# ------------------
pdf("../results/weak-scaling.pdf")
# One node weak
plot(x = weak$Rectangles[1:4], y = weak$Serial[1:4], type = "o", xlab = "Rectangles", ylab = "Time", main = "Weak Scaling (One Node)", ylim = range(weak$Serial[1:4], weak$OpenMP[1:12], weak$Hybrid), xlim = range(weak$Rectangles[1:12]))
lines(weak$Rectangles[1:12], weak$OpenMP[1:12], type = "o", col = "Blue")
lines(weak$Rectangles[1:12], weak$Hybrid[1:12], type = "o", col = "Red")
legend("topright", c("Serial", "OpenMP", "Hybrid"), lty = c(1,1,1), col = c("Black", "Blue", "Red"))

# Two node weak
plot(x = weak$Rectangles[13:14], y = weak$Serial[seq(2,4,2)], type = "o", xlab = "Rectangles", ylab = "Time", main = "Strong Scaling (Two Nodes)", ylim = range(weak$Serial[1:4], weak$OpenMP[1:12], weak$Hybrid), xlim = range(weak$Rectangles[13:24]))
lines(weak$Rectangles[13:18], weak$OpenMP[seq(2,12,2)], type = "o", col = "Blue")
lines(weak$Rectangles[13:24], weak$Hybrid[13:24], type = "o", col = "Red")
legend("topright", c("Serial Model", "OpenMP Model", "Hybrid"), lty = c(1,1,1), col = c("Black", "Blue", "Red"))
dev.off()

# Output all results to csv file
write.csv(strong, file = "../results/strong.csv", row.names = FALSE)
write.csv(weak, file = "../results/weak.csv", row.names = FALSE)
