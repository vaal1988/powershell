try { 
  puppet agent -t
} catch { 
  puppet ssl clean
  puppet agent -t
}
