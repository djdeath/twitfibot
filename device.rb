LOCAL_OUI_FILE_PATH = "./oui.txt"
VENDOR_STR_LENGTH=30

class Device    
  def initialize( time, sa, da, ss, ssid)  
    # Instance variables  
    @mac =   sa
    @time = time
    @ss =   ss
    @ssids = [ssid]
    @vendor = lookup_vendor(@mac)
  end
  def anonymizeMac(mac)
    array = mac.split(':')
    res = "#{array[0]}:#{array[1]}:#{array[2]}:#{array[3]}:#{array[4]}:XX"
    return res
  end
  
  def mac
    @mac
  end
  def macanon
    anonymizeMac(@mac)
  end
  def time 
    @time
  end
  def ss
    @ss
  end
  def ssids
    @ssids
  end
  def vendor
    @vendor
  end
  def nbssids
    n =0
    ssids.each do |ssid|
      if(ssid != "") then 
        n+=1
      end
    end
    return n
  end
  
  # part of this function come from zizap ouilookup code  https://github.com/zipizap/ouilookup
  def lookup_vendor(mac)
    local_oui_content = File.read(LOCAL_OUI_FILE_PATH) #,mode:"r:UTF-8")            # read LOCAL_OUI_FILE_PATH
    #local_oui_content.encode!('UTF-8','UTF-8',:invalid => :replace)       
    mac = mac.upcase
    mac_prefix = mac[0,8]                                         # "00:1A:22"
    
    mac_prefix_normalized = mac_prefix.gsub(':','-')              # "00-1A-22"
    mac_prefix_normalized_regexp = Regexp.new(Regexp.escape(mac_prefix_normalized))      

    local_mac_data = local_oui_content.lines.grep(mac_prefix_normalized_regexp)[0]||""       #"00-00-FF   (hex)\t\tCAMTEC ELECTRONICS LTD.\n" or ""
    org = local_mac_data.chomp.split("\t")[-1]||""                #"CAMTEC ELECTRONICS LTD." or ""
    return org
    #vendor = org.ljust(VENDOR_STR_LENGTH,' ')[0..VENDOR_STR_LENGTH-1].chomp().lstrip()
    #return org.ljust(VENDOR_STR_LENGTH,' ')[0..VENDOR_STR_LENGTH-1].chomp().lstrip()
  end
  def update(time,ss,ssid)
    @time = time
    @ss = ss
    if(@ssids.include?(ssid)) then 
    else
      @ssids+=[ssid]
      return true
    end
  end
  def display  
    print "#{@vendor}| #{@mac} | #{@ss} dB | #{@ssids.size} | "
    sep=''
    @ssids.each do |ssid| print "#{sep}'#{ssid}'" 
    sep=','
    end
    puts
  end  
  def is_blind()
    if(@ssids.length==1 && @ssids[0]=='')   then 
      return true
    else
      return false
    end
    
  end
  def get_ssids()
    return @ssids
  end
  def get_time()
    return @time
  end
end  
