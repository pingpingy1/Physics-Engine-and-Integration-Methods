library(ggplot2)
library(tidyverse)

## xpos1
xpos1 <- read.csv("x1_pos.csv")
head(xpos1)

# Simple plotting
# Preparing data
tidy.x1 <- xpos1 %>%
  select(Time, Actual, Explicit.Euler, Simpletic.Euler, Verlet) %>%
  gather(key = "integration_method", value = "x1", -Time)
head(tidy.x1)

# Plotting graph
ggplot(tidy.x1, aes(x = Time, y = x1)) +
  geom_line(aes(color = integration_method,
                size = integration_method,
                linetype = integration_method)) +
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
  scale_size_manual(values = c(2, 1, 1, 1, 1),
                    limits = c("Actual",
                               "Explicit.Euler",
                               "Simpletic.Euler",
                               "Verlet"),
                    labels = c("Theoretical",
                               "Explicit Euler",
                               "Simpletic Euler",
                               "Verlet")) +
  scale_linetype_manual(values = c("solid",
                                   "solid",
                                   "solid",
                                   "dashed"),
                        limits = c("Actual",
                                   "Explicit.Euler",
                                   "Simpletic.Euler",
                                   "Verlet"),
                        labels = c("Theoretical",
                                   "Explicit Euler",
                                   "Simpletic Euler",
                                   "Verlet")) +
  ggtitle("Spring with Length, X-Position of Particle 1") +
  labs(x = "Time",
       y = "X-Position",
       color = "Integration Method",
       size = "Integration Method",
       linetype = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("x1_plot.pdf", width = 24, height = 18, units = "cm")

# Plotting error
# Preparing data
x1.error <- data.frame(xpos1$Time)
names(x1.error) <- "Time"
x1.error$Explicit.Euler <- xpos1$Explicit.Euler - xpos1$Actual
x1.error$Simpletic.Euler <- xpos1$Simpletic.Euler - xpos1$Actual
x1.error$Verlet <- xpos1$Verlet - xpos1$Actual
head(x1.error)

## Error magnitude for particle 1
ypos1 <- read.csv("y1_pos.csv")
head(ypos1)
y1.error <- data.frame(ypos1$Time)
names(y1.error) <- "Time"
y1.error$Explicit.Euler <- ypos1$Explicit.Euler - ypos1$Actual
y1.error$Simpletic.Euler <- ypos1$Simpletic.Euler - ypos1$Actual
y1.error$Verlet <- ypos1$Verlet - ypos1$Actual
head(y1.error)

error1.mag <- data.frame(x1.error$Time)
names(error1.mag) <- "Time"
error1.mag$Explicit.Euler <- sqrt(x1.error$Explicit.Euler^2 + y1.error$Explicit.Euler^2)
error1.mag$Simpletic.Euler <- sqrt(x1.error$Simpletic.Euler^2 + y1.error$Simpletic.Euler^2)
error1.mag$Verlet <- sqrt(x1.error$Verlet^2 + y1.error$Verlet^2)
head(error1.mag)

# Preparing data
tidy.error1.mag <- error1.mag %>%
  select(Time, Explicit.Euler, Simpletic.Euler, Verlet) %>%
  gather(key = "integration_method", value = "error1", -Time)
head(tidy.error1.mag)

# Plotting graph
ggplot(tidy.error1.mag, aes(x = Time, y = error1)) +
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
  ggtitle("Spring with Length, Magnitude of Error of Particle 1") +
  labs(x = "Time",
       y = "Error",
       color = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("error1_plot.pdf", width = 24, height = 18, units = "cm")

## Error magnitude for particle 2
xpos2 <- read.csv("x2_pos.csv")
ypos2 <- read.csv("y2_pos.csv")
error2.mag <- data.frame(xpos2$Time)
names(error2.mag) <- "Time"
error2.mag$Explicit.Euler <- sqrt((xpos2$Explicit.Euler - xpos2$Actual)^2
                                  +
                                    (ypos2$Explicit.Euler - ypos2$Actual)^2)
error2.mag$Simpletic.Euler <- sqrt((xpos2$Simpletic.Euler - xpos2$Actual)^2
                                   +
                                     (ypos2$Simpletic.Euler - ypos2$Actual)^2)
error2.mag$Verlet <- sqrt((xpos2$Verlet - xpos2$Actual)^2
                          +
                            (ypos2$Verlet - ypos2$Actual)^2)
head(error2.mag)

# Preparing data
tidy.error2.mag <- error2.mag %>%
  select(Time, Explicit.Euler, Simpletic.Euler, Verlet) %>%
  gather(key = "integration_method", value = "error1", -Time)
head(tidy.error2.mag)

# Plotting graph
ggplot(tidy.error1.mag, aes(x = Time, y = error1)) +
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
  ggtitle("Spring with Length, Magnitude of Error of Particle 2") +
  labs(x = "Time",
       y = "Error",
       color = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("error2_plot.pdf", width = 24, height = 18, units = "cm")

