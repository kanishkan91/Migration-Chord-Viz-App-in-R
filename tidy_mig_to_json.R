tidy_mig_to_matrix <- function(d){
  # for a single year
  d %>%
    select(-year0) %>%
    spread(key = dest, value = flow) %>%
    select(-orig) %>%
    set_names(NULL) %>%
    as.matrix()
}

tidy_mig_to_json <- function(df_flow = NULL, df_region = NULL,
                             region_names = NULL,
                             region_label1 = NULL, region_label2 = NULL, region_col = NULL){
  df0 <- df_region %>%
    mutate(region = factor(region, levels = region_names)) %>%
    arrange(region, name) %>%
    group_by(region) %>%
    summarise(name = paste(name, collapse = " :: ")) %>%
    mutate(all = paste0(as.character(region), " :: ", name))

  all_order <- strsplit(df0$all, " :: ") %>%
    unlist() %>%
    unique()

  df1 <- df_flow %>%
    left_join(df_region, by = c("orig"="alpha3")) %>%
    rename(orig_reg = region, orig_name = name) %>%
    left_join(df_region, by = c("dest"="alpha3")) %>%
    rename(dest_reg = region, dest_name = name)  %>%
    mutate_if(is.factor, as.character) %>%
    # have to build orig and dest vars that are mix of countries and regions in this and next df
    mutate(orig = orig_name,
           dest = dest_name)

    # mutate(orig_name = factor(orig_name, levels = all_order),
    #        dest_name = factor(dest_name, levels = all_order))

  df2 <- df1 %>%
    group_by(year0, orig_reg, dest_reg) %>%
    summarise(flow = sum(flow)) %>%
    ungroup() %>%
    mutate(orig = orig_reg, dest = dest_reg) %>%
    mutate_if(is.factor, as.character)

  df3 <- df1 %>%
    group_by(year0, orig_reg, dest) %>%
    summarise(flow = sum(flow)) %>%
    ungroup() %>%
    mutate(orig = orig_reg) %>%
    mutate_if(is.factor, as.character)

  df4 <- df1 %>%
    group_by(year0, orig, dest_reg) %>%
    summarise(flow = sum(flow)) %>%
    ungroup() %>%
    mutate(dest = dest_reg) %>%
    mutate_if(is.factor, as.character)

  df5 <- df1 %>%
    bind_rows(df2) %>%
    bind_rows(df3) %>%
    bind_rows(df4) %>%
    select(year0, orig, dest, flow) %>%
    mutate(orig = factor(orig, levels = all_order),
           dest = factor(dest, levels = all_order)) %>%
    arrange(year0, dest, orig) %>%
    droplevels()

  l0 <- split(df5, df5$year0, drop = TRUE)
  l1 <- lapply(l0, tidy_mig_to_matrix)
  # str(l1)
  # l2 <- toJSON(l1, matrix="rowmajor")

  # a0 <- xtabs(flow ~ orig + dest + year0, data = df5) %>%
  #   as.array()
  # l0 <- lapply(1:dim(a0)[3], function(i) a0[,,i])
  # l0 <- lapply(l0, as.matrix)
  # str(l0)
  # names(l0) <- dimnames(a0)[[3]]

  l2 <- list(names = all_order,
             name1 = region_label1,
             name2 = region_label2,
             reg_col = region_col,
             regions = match(x = region_names, table = all_order)-1,
             matrix = l1)
  return(l2)
}
