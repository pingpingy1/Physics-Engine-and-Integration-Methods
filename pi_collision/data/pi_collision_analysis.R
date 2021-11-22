library(ggplot2)
library(tidyverse)

## xpos1
xpos1 <- read.csv("x1_pos.csv")
head(xpos1)

# Simple plotting
# Preparing data
tidy.x1 <- xpos1 %>%
  select(Time, Actual, Explicit.Euler, Simpletic.Euler) %>%
  gather(key = "integration_method", value = "x1", -Time)
head(tidy.x1)

# Plotting graph
ggplot(tidy.x1, aes(x = Time, y = x1)) +
  geom_line(aes(color = integration_method,
                linetype = integration_method)) +
  scale_color_manual(values = c("black",
                                "red",
                                "green"),
                     limits = c("Actual",
                                "Explicit.Euler",
                                "Simpletic.Euler"),
                     labels = c("Theoretical",
                                "Explicit Euler",
                                "Simpletic Euler")) +
  scale_linetype_manual(values = c("solid",
                                   "solid",
                                   "dashed"),
                        limits = c("Actual",
                                   "Explicit.Euler",
                                   "Simpletic.Euler"),
                        labels = c("Theoretical",
                                   "Explicit Euler",
                                   "Simpletic Euler")) +
  ggtitle("Pi_Collision, X-Position of Particle 1") +
  labs(x = "Time",
       y = "X-Position",
       color = "Integration Method",
       linetype = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("x1_plot.pdf", width = 24, height = 18, units = "cm")

## Plotting error
# Preparing data
x1.error <- data.frame(xpos1$Time)
names(x1.error) <- "Time"
x1.error$Explicit.Euler <- xpos1$Explicit.Euler - xpos1$Actual
x1.error$Simpletic.Euler <- xpos1$Simpletic.Euler - xpos1$Actual
head(x1.error)

tidy.x1.error <- x1.error %>%
  select(Time, Explicit.Euler, Simpletic.Euler) %>%
  gather(key = "integration_method", value = "x1", -Time)
head(tidy.x1.error)

# Plotting graph
ggplot(tidy.x1.error, aes(x = Time, y = x1)) +
  geom_line(aes(color = integration_method,
                linetype = integration_method)) +
  scale_color_manual(values = c("red",
                                "green"),
                     limits = c("Explicit.Euler",
                                "Simpletic.Euler"),
                     labels = c("Explicit Euler",
                                "Simpletic Euler")) +
  scale_linetype_manual(values = c("solid",
                                   "dashed"),
                        limits = c("Explicit.Euler",
                                   "Simpletic.Euler"),
                        labels = c("Explicit Euler",
                                   "Simpletic Euler")) +
  ggtitle("Pi_Collision, Error of X-Position of Particle 1") +
  labs(x = "Time",
       y = "Error of X-Position",
       color = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("x1_error_plot.pdf", width = 24, height = 18, units = "cm")

## xpos2
xpos2 <- read.csv("x2_pos.csv")
head(xpos2)

# Simple plotting
# Preparing data
tidy.x2 <- xpos2 %>%
  select(Time, Actual, Explicit.Euler, Simpletic.Euler) %>%
  gather(key = "integration_method", value = "x2", -Time)
head(tidy.x2)

# Plotting graph
ggplot(tidy.x2, aes(x = Time, y = x2)) +
  geom_line(aes(color = integration_method,
                linetype = integration_method)) +
  scale_color_manual(values = c("black",
                                "red",
                                "green"),
                     limits = c("Actual",
                                "Explicit.Euler",
                                "Simpletic.Euler"),
                     labels = c("Theoretical",
                                "Explicit Euler",
                                "Simpletic Euler")) +
  scale_linetype_manual(values = c("solid",
                                   "solid",
                                   "dashed"),
                        limits = c("Actual",
                                   "Explicit.Euler",
                                   "Simpletic.Euler"),
                        labels = c("Theoretical",
                                   "Explicit Euler",
                                   "Simpletic Euler")) +
  ggtitle("Pi_Collision, X-Position of Particle 2") +
  labs(x = "Time",
       y = "X-Position",
       color = "Integration Method",
       size = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("x2_plot.pdf", width = 24, height = 18, units = "cm")

## Plotting error
# Preparing data
x2.error <- data.frame(xpos2$Time)
names(x2.error) <- "Time"
x2.error$Explicit.Euler <- xpos2$Explicit.Euler - xpos2$Actual
x2.error$Simpletic.Euler <- xpos2$Simpletic.Euler - xpos2$Actual
head(x2.error)

tidy.x2.error <- x2.error %>%
  select(Time, Explicit.Euler, Simpletic.Euler) %>%
  gather(key = "integration_method", value = "x2", -Time)
head(tidy.x2.error)

# Plotting graph
ggplot(tidy.x2.error, aes(x = Time, y = x2)) +
  geom_line(aes(color = integration_method,
                linetype = integration_method)) +
  scale_color_manual(values = c("red",
                                "green"),
                     limits = c("Explicit.Euler",
                                "Simpletic.Euler"),
                     labels = c("Explicit Euler",
                                "Simpletic Euler")) +
  scale_linetype_manual(values = c("solid",
                                   "dashed"),
                        limits = c("Explicit.Euler",
                                   "Simpletic.Euler"),
                        labels = c("Explicit Euler",
                                   "Simpletic Euler")) +
  ggtitle("Pi_Collision, Error of X-Position of Particle 2") +
  labs(x = "Time",
       y = "Error of X-Position",
       color = "Integration Method") +
  theme(plot.title = element_text(size = rel(1.5)))

# Saving as PDF
ggsave("x2_error_plot.pdf", width = 24, height = 18, units = "cm")





