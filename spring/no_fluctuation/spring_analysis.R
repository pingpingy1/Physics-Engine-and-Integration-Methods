library(ggplot2)
library(tidyverse)

## xpos
xpos <- read.csv("x_pos.csv")
head(xpos)

# Simple plotting
# Preparing data
tidy.x <- xpos %>%
  select(Time, Actual, Explicit.Euler, Simpletic.Euler, Verlet) %>%
  gather(key = "integration_method", value = "x", -Time)
head(tidy.x)

# Plotting graph
ggplot(tidy.x, aes(x = Time, y = x)) +
  geom_line(aes(color = integration_method,
                size = integration_method)) +
  scale_color_manual(values = c("black",
                                "red",
                                "green",
                                "blue"),
                     limits = c("Actual",
                                "Explicit.Euler",
                                "Simpletic.Euler",
                                "Verlet"),
                     labels = c("Theoretical",
                                "Explicit Euler",
                                "Simpletic Euler",
                                "Verlet")) +
  scale_size_manual(values = c(2, 1, 1, 1),
                    limits = c("Actual",
                               "Explicit.Euler",
                               "Simpletic.Euler",
                               "Verlet"),
                    labels = c("Theoretical",
                               "Explicit Euler",
                               "Simpletic Euler",
                               "Verlet")) +
  ggtitle("Spring, X-Position") +
  labs(x = "Time",
       y = "X-Position",
       color = "Integration Method",
       size = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("x_plot.pdf", width = 24, height = 18, units = "cm")

## ypos
ypos <- read.csv("y_pos.csv")
head(ypos)

# Simple plotting
# Preparing data
tidy.y <- ypos %>%
  select(Time, Actual, Explicit.Euler, Simpletic.Euler, Verlet) %>%
  gather(key = "integration_method", value = "y", -Time)
head(tidy.y)

# Plotting graph
ggplot(tidy.y, aes(x = Time, y = y)) +
  geom_line(aes(color = integration_method,
                size = integration_method)) +
  scale_color_manual(values = c("black",
                                "red",
                                "green",
                                "blue"),
                     limits = c("Actual",
                                "Explicit.Euler",
                                "Simpletic.Euler",
                                "Verlet"),
                     labels = c("Theoretical",
                                "Explicit Euler",
                                "Simpletic Euler",
                                "Verlet")) +
  scale_size_manual(values = c(2, 1, 1, 1),
                    limits = c("Actual",
                               "Explicit.Euler",
                               "Simpletic.Euler",
                               "Verlet"),
                    labels = c("Theoretical",
                               "Explicit Euler",
                               "Simpletic Euler",
                               "Verlet")) +
  ggtitle("Spring, Y-Position") +
  labs(x = "Time",
       y = "Y-Position",
       color = "Integration Method",
       size = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("y_plot.pdf", width = 24, height = 18, units = "cm")

## Plotting error
# Preparing data
x.error <- data.frame(xpos$Time)
names(x.error) <- "Time"
x.error$Explicit.Euler <- xpos$Explicit.Euler - xpos$Actual
x.error$Simpletic.Euler <- xpos$Simpletic.Euler - xpos$Actual
x.error$Verlet <- xpos$Verlet - xpos$Actual
head(x.error)

ypos <- read.csv("y_pos.csv")
head(ypos)
y.error <- data.frame(ypos$Time)
names(y.error) <- "Time"
y.error$Explicit.Euler <- ypos$Explicit.Euler - ypos$Actual
y.error$Simpletic.Euler <- ypos$Simpletic.Euler - ypos$Actual
y.error$Verlet <- ypos$Verlet - ypos$Actual
head(y.error)

error.mag <- data.frame(x.error$Time)
names(error.mag) <- "Time"
error.mag$Explicit.Euler <- sqrt(x.error$Explicit.Euler^2 + y.error$Explicit.Euler^2)
error.mag$Simpletic.Euler <- sqrt(x.error$Simpletic.Euler^2 + y.error$Simpletic.Euler^2)
error.mag$Verlet <- sqrt(x.error$Verlet^2 + y.error$Verlet^2)
head(error.mag)

# Preparing data
tidy.error.mag <- error.mag %>%
  select(Time, Explicit.Euler, Simpletic.Euler, Verlet) %>%
  gather(key = "integration_method", value = "error", -Time)
head(tidy.error.mag)

# Plotting graph
ggplot(tidy.error.mag, aes(x = Time, y = error)) +
  geom_line(aes(color = integration_method)) +
  scale_color_manual(values = c("red",
                                "green",
                                "blue"),
                     limits = c("Explicit.Euler",
                                "Simpletic.Euler",
                                "Verlet"),
                     labels = c("Explicit Euler",
                                "Simpletic Euler",
                                "Verlet")) +
  ggtitle("Spring, Magnitude of Error") +
  labs(x = "Time",
       y = "Error",
       color = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("error_plot.pdf", width = 24, height = 18, units = "cm")






