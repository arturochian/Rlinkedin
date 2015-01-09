unlistWithNAs <- function(node_set, node_path)
{
  x.list <- lapply(node_set, xpathSApply, node_path, xmlValue)
  x.list[sapply(x.list, is.list)] <- NA
  x.list <- unlist(x.list)
}

nullObjTest <- function(x) is.null(x) | all(sapply(x, is.null))  

rmNullElements <- function(x)
{
  x <- Filter(Negate(nullObjTest),x)
  lapply(x, function(x) if (is.list(x)) rmNullElements(x) else x)
}


listToXML <- function(node, sublist)
{
  sublist <- rmNullElements(sublist)
  for(i in 1:length(sublist)){
    child <- newXMLNode(names(sublist)[i], parent=node)  
    if (typeof(sublist[[i]]) == "list"){
      listToXML(child, sublist[[i]])
    }
    else{
      xmlValue(child) <- sublist[[i]]
    }
  } 
}


jobsToDF <- function(x)
{
  nodes <- getNodeSet(x, "//job")
  
  q.df <- data.frame(job_id=unlistWithNAs(nodes, "./id"),
                     company_id=unlistWithNAs(nodes, "./company/id"),
                     company_name=unlistWithNAs(nodes, "./company/name"),
                     poster_id=unlistWithNAs(nodes, "./job-poster/id"),
                     poster_fname=unlistWithNAs(nodes, "./job-poster/first-name"),
                     poster_lname=unlistWithNAs(nodes, "./job-poster/last-name"),
                     job_headline=unlistWithNAs(nodes, "./job-poster/headline"),
                     salary=unlistWithNAs(nodes, "./salary"),
                     job_desc=unlistWithNAs(nodes, "./description-snippet"),
                     location=unlistWithNAs(nodes, "./location-description")
                     )
  return(df)
}



jobBookmarksToDF <- function(x)
{
  nodes <- getNodeSet(x, "//job-bookmark")
  
  q.df <- data.frame(app_status=unlistWithNAs(nodes, "./is-applied"),
                   saved_time=unlistWithNAs(nodes, "./saved-timestamp"),
                   job_id=unlistWithNAs(nodes, "./job/id"), 
                   job_status=unlistWithNAs(nodes, "./job/active"),
                   company_id=unlistWithNAs(nodes, "./job/company/id"),
                   company_name=unlistWithNAs(nodes, "./job/company/name"),
                   job_title=unlistWithNAs(nodes, "./job/position/title"),
                   job_desc=unlistWithNAs(nodes, "./job/description-snippet"),
                   post_timestamp=unlistWithNAs(nodes, "./job/posting-timestamp")
                   )
  return(df)
}



groupsToDF <- function(x)
{
  nodes <- getNodeSet(x, "//group-membership")
  
  q.df <- data.frame(group_id=unlistWithNAs(nodes, "./group/id"),
                     group_name=unlistWithNAs(nodes, "./group/name"),
                     member_status=unlistWithNAs(nodes, "./membership-state/code"),
                     allow_messages_from_members=unlistWithNAs(nodes, "./allow-messages-from-members"),
                     email_frequency=unlistWithNAs(nodes, "./email-digest-frequency/code"),
                     manager_announcements=unlistWithNAs(nodes, "./email-annoucements-from-managers"),
                     email_new_posts=unlistWithNAs(nodes, "./email-for-every-new-post")
                     )
  return(q.df)
}


groupPostToDF <- function(x)
{ 
  nodes <- getNodeSet(x, "//post")

  q.df <- data.frame(post_id=unlistWithNAs(nodes, "./id"),
                     post_type=unlistWithNAs(nodes, "./type/code"),
                     creator_id=unlistWithNAs(nodes, "./creator/id"),
                     creator_fname=unlistWithNAs(nodes, "./creator/fname"),
                     creator_lname=unlistWithNAs(nodes, "./creator/lname"),
                     headline=unlistWithNAs(nodes, "./creator/headline"),
                     title=unlistWithNAs(nodes, "./title")
  )
  return(q.df)
}

