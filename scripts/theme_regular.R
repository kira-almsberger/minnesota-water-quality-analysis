# Set up graphs so its less code throughout
# Theme for Graphs
# Make a new default theme
# Run this and it will store it as an object for use later
theme_regular <- function(base_size = 14, base_family = "sans") {
  theme(
    # --- GLOBAL TEXT ---
    # Sets the baseline for all text in the plot
    text = element_text(
      family = base_family,
      size = base_size,
      colour = "black"
    ),
    
    # --- PLOT ELEMENTS (Outer Canvas) ---
    plot.background = element_rect(fill = "white", colour = NA), # Entire plot background
    plot.title = element_text(face = "bold", size = rel(1.2)), # Main plot title
    plot.subtitle = element_text(face = "plain", size = rel(1)), # Plot subtitle
    plot.caption = element_text(face = "italic", size = rel(0.8)), # Data source/caption
    
    # --- AXIS LINES ---
    axis.line = element_line(colour = "black", linewidth = 0.5), # Base for all axis lines
    axis.line.x = element_line(colour = "black"), # X-axis line specifically
    axis.line.y = element_line(colour = "black"), # Y-axis line specifically
    
    # --- AXIS TICKS ---
    axis.ticks = element_line(colour = "black", linewidth = 0.5), # Base for all tick marks
    axis.ticks.x = element_line(colour = "black"), # X-axis tick marks
    axis.ticks.y = element_line(colour = "black"), # Y-axis tick marks
    
    # --- AXIS TITLES ---
    axis.title = element_text(face = "bold", size = base_size), # Base for all axis titles
    axis.title.x = element_text(margin = margin(t = 10)), # X-axis title (t = space above)
    axis.title.y = element_text(margin = margin(r = 10), angle = 90), # Y-axis title (r = space right)
    
    # --- AXIS TEXT (Tick Labels) ---
    axis.text = element_text(colour = "gray20"), # Base for all tick labels
    axis.text.x = element_text(angle = 0, vjust = 0.5, hjust = 0.5), # X-axis labels (angled for readability)
    axis.text.y = element_text(margin = margin(r = 5)), # Y-axis labels
    
    # --- PANEL ELEMENTS (Inner Graph Area) ---
    panel.background = element_rect(fill = "white", colour = NA), # Inner plot background
    panel.border = element_rect(fill = NA, colour = "black"), # Box around the inner plot
    
    # --- PANEL GRID LINES ---
    panel.grid.major =  element_blank(), # element_line(colour = "gray90", linetype = "solid"), # Base major grid lines
    panel.grid.major.x = element_blank(), # Vertical major lines (turned off)
    panel.grid.major.y = element_blank(), # element_line(colour = "gray85"), # Horizontal major lines
    panel.grid.minor = element_blank(), # Minor grid lines (turned off)
    panel.grid.minor.x = element_blank(), # Vertical minor lines
    panel.grid.minor.y = element_blank(), # Horizontal minor lines
    
    # --- LEGEND ---
    legend.position = "right", # Move legend below the plot
    legend.background = element_rect(fill = "white", colour = NA), # Legend bounding box
    legend.key = element_rect(fill = NA, colour = NA), # Background behind legend symbols
    legend.title = element_text(face = "bold", size = rel(1.1)), # Legend title
    legend.text = element_text(face = "plain", size = rel(0.9)), # Legend items
    
    # --- FACET STRIPS (For facet_wrap/facet_grid) ---
    strip.background = element_rect(fill = "gray90", colour = "black"), # Box behind facet labels
    strip.text = element_text(face = "bold", size = base_size), # Base facet text
    strip.text.x = element_text(margin = margin(t = 5, b = 5)), # Top facet labels
    strip.text.y = element_text(angle = -90) # Side facet labels (for facet_grid)
  )
}
