library(ggplot2)
library(tidyverse)

### No Fluctuation

## xpos1
xpos1 <- read.csv("no_fluctuation/x1_pos.csv")
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
  ggtitle("Planetary, X-Position of Particle 1") +
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

tidy.x1.error <- x1.error %>%
  select(Time, Explicit.Euler, Simpletic.Euler, Verlet) %>%
  gather(key = "integration_method", value = "x1", -Time)
head(tidy.x1.error)

# Plotting graph
ggplot(tidy.x1.error, aes(x = Time, y = x1)) +
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
  ggtitle("Planetary, Error of X-Position of Particle 1") +
  labs(x = "Time",
       y = "Error of X-Position",
       color = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("x1_error_plot.pdf", width = 24, height = 18, units = "cm")

## Error magnitude for particle 1
ypos1 <- read.csv("no_fluctuation/y1_pos.csv")
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
  ggtitle("Planetary, Magnitude of Error of Particle 1") +
  labs(x = "Time",
       y = "Error",
       color = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("error1_plot.pdf", width = 24, height = 18, units = "cm")

## Error magnitude for particle 2
xpos2 <- read.csv("no_fluctuation/x2_pos.csv")
ypos2 <- read.csv("no_fluctuation/y2_pos.csv")
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
  ggtitle("Planetary, Magnitude of Error of Particle 2") +
  labs(x = "Time",
       y = "Error",
       color = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("error2_plot.pdf", width = 24, height = 18, units = "cm")

#####################################################

### Fluctuation

## Particle 1
fluc.xpos1 <- read.csv("fluctuation/x1_pos.csv")
fluc.ypos1 <- read.csv("fluctuation/y1_pos.csv")
fluc.error1.mag <- data.frame(fluc.xpos1$Time)
names(fluc.error1.mag) <- "Time"
fluc.error1.mag$Explicit.Euler <- sqrt((fluc.xpos1$Explicit.Euler - fluc.xpos1$Actual)^2
                                       + (fluc.ypos1$Explicit.Euler - fluc.ypos1$Actual)^2)
fluc.error1.mag$Simpletic.Euler <- sqrt((fluc.xpos1$Simpletic.Euler - fluc.xpos1$Actual)^2
                                        + (fluc.ypos1$Simpletic.Euler - fluc.ypos1$Actual)^2)
fluc.error1.mag$Verlet <- sqrt((fluc.xpos1$Verlet - fluc.xpos1$Actual)^2
                               + (fluc.ypos1$Verlet - fluc.ypos1$Actual)^2)
head(fluc.error1.mag)

# Data Preparation
error1.mag$Fluctuation <- rep(FALSE, length(error1.mag$Time))
fluc.error1.mag$Fluctuation <- rep(TRUE, length(fluc.error1.mag$Time))
all.error1.mag <- rbind(error1.mag, fluc.error1.mag)
head(all.error1.mag)

tidy.all.error1.mag <- all.error1.mag %>%
  gather(key = "integration_method", value = "error1", -Time, -Fluctuation)
head(tidy.all.error1.mag)

# Plotting graph
ggplot(tidy.all.error1.mag, aes(x = Time, y = error1)) +
  geom_line(aes(color = integration_method,
                linetype = Fluctuation)) +
  scale_color_manual(values = c("red",
                                "green",
                                "blue"),
                     limits = c("Explicit.Euler",
                                "Simpletic.Euler",
                                "Verlet"),
                     labels = c("Explicit Euler",
                                "Simpletic Euler",
                                "Verlet")) +
  scale_linetype_manual(values = c("dashed",
                                "solid"),
                     limits = c(FALSE,
                                TRUE),
                     labels = c("No",
                                "Yes")) +
  ggtitle("Planetary, Magnitude of Error of Particle 1, With or Without Fluctuation") +
  labs(x = "Time",
       y = "Error",
       color = "Integration Method",
       linetype = "Fluctuation") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("all_error1_plot.pdf", width = 24, height = 18, units = "cm")

## Particle 2
fluc.xpos2 <- read.csv("fluctuation/x2_pos.csv")
fluc.ypos2 <- read.csv("fluctuation/y2_pos.csv")
fluc.error2.mag <- data.frame(fluc.xpos2$Time)
names(fluc.error2.mag) <- "Time"
fluc.error2.mag$Explicit.Euler <- sqrt((fluc.xpos2$Explicit.Euler - fluc.xpos2$Actual)^2
                                       + (fluc.ypos2$Explicit.Euler - fluc.ypos2$Actual)^2)
fluc.error2.mag$Simpletic.Euler <- sqrt((fluc.xpos2$Simpletic.Euler - fluc.xpos2$Actual)^2
                                        + (fluc.ypos2$Simpletic.Euler - fluc.ypos2$Actual)^2)
fluc.error2.mag$Verlet <- sqrt((fluc.xpos2$Verlet - fluc.xpos2$Actual)^2
                               + (fluc.ypos2$Verlet - fluc.ypos2$Actual)^2)
head(fluc.error2.mag)

# Data Preparation
error2.mag$Fluctuation <- rep(FALSE, length(error2.mag$Time))
fluc.error2.mag$Fluctuation <- rep(TRUE, length(fluc.error2.mag$Time))
all.error2.mag <- rbind(error2.mag, fluc.error2.mag)
head(all.error2.mag)

tidy.all.error2.mag <- all.error2.mag %>%
  gather(key = "integration_method", value = "error2", -Time, -Fluctuation)
head(tidy.all.error2.mag)

# Plotting graph
ggplot(tidy.all.error2.mag, aes(x = Time, y = error2)) +
  geom_line(aes(color = integration_method,
                linetype = Fluctuation)) +
  scale_color_manual(values = c("red",
                                "green",
                                "blue"),
                     limits = c("Explicit.Euler",
                                "Simpletic.Euler",
                                "Verlet"),
                     labels = c("Explicit Euler",
                                "Simpletic Euler",
                                "Verlet")) +
  scale_linetype_manual(values = c("dashed",
                                   "solid"),
                        limits = c(FALSE,
                                   TRUE),
                        labels = c("No",
                                   "Yes")) +
  ggtitle("Planetary, Magnitude of Error of Particle 2, With or Without Fluctuation") +
  labs(x = "Time",
       y = "Error",
       color = "Integration Method",
       linetype = "Fluctuation") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("all_error2_plot.pdf", width = 24, height = 18, units = "cm")









