library(ggplot2)
library(tidyverse)

### No Fluctuation

## xpos
xpos <- read.csv("no_fluctuation/x_pos.csv")
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
  ggtitle("Spring, X-Position") +
  labs(x = "Time",
       y = "X-Position",
       color = "Integration Method",
       size = "Integration Method",
       linetype = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("x_plot.pdf", width = 24, height = 18, units = "cm")

# Plotting error
# Preparing data
x.error <- data.frame(xpos$Time)
names(x.error) <- "Time"
x.error$Explicit.Euler <- xpos$Explicit.Euler - xpos$Actual
x.error$Simpletic.Euler <- xpos$Simpletic.Euler - xpos$Actual
x.error$Verlet <- xpos$Verlet - xpos$Actual
head(x.error)

tidy.x.error <- x.error %>%
  select(Time, Explicit.Euler, Simpletic.Euler, Verlet) %>%
  gather(key = "integration_method", value = "x", -Time)
head(tidy.x.error)

# Plotting graph
ggplot(tidy.x.error, aes(x = Time, y = x)) +
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
  ggtitle("Spring, Error of X-Position") +
  labs(x = "Time",
       y = "Error of X-Position",
       color = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("x_error_plot.pdf", width = 24, height = 18, units = "cm")

## Error magnitude
ypos <- read.csv("no_fluctuation/y_pos.csv")
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

#####################################################

### Fluctuation

## Particle 1
fluc.xpos <- read.csv("fluctuation/x_pos.csv")
fluc.ypos <- read.csv("fluctuation/y_pos.csv")
fluc.error.mag <- data.frame(fluc.xpos$Time)
names(fluc.error.mag) <- "Time"
fluc.error.mag$Explicit.Euler <- sqrt((fluc.xpos$Explicit.Euler - fluc.xpos$Actual)^2
                                       + (fluc.ypos$Explicit.Euler - fluc.ypos$Actual)^2)
fluc.error.mag$Simpletic.Euler <- sqrt((fluc.xpos$Simpletic.Euler - fluc.xpos$Actual)^2
                                        + (fluc.ypos$Simpletic.Euler - fluc.ypos$Actual)^2)
fluc.error.mag$Verlet <- sqrt((fluc.xpos$Verlet - fluc.xpos$Actual)^2
                               + (fluc.ypos$Verlet - fluc.ypos$Actual)^2)
head(fluc.error.mag)

# Data Preparation
error.mag$Fluctuation <- rep(FALSE, length(error.mag$Time))
fluc.error.mag$Fluctuation <- rep(TRUE, length(fluc.error.mag$Time))
all.error.mag <- rbind(error.mag, fluc.error.mag)
head(all.error.mag)

tidy.all.error.mag <- all.error.mag %>%
  gather(key = "integration_method", value = "error", -Time, -Fluctuation)
head(tidy.all.error.mag)

# Plotting graph
ggplot(tidy.all.error.mag, aes(x = Time, y = error)) +
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
  ggtitle("Spring, Magnitude of Error, With or Without Fluctuation") +
  labs(x = "Time",
       y = "Error",
       color = "Integration Method",
       linetype = "Fluctuation") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("all_error_plot.pdf", width = 24, height = 18, units = "cm")










