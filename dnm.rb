require "sinatra"

require "./fonks.rb"

@@m = []
@@s = ""
(1..81).each do
    @@m << "123456789"
end

def check
    #tekleri bul
    singles=[]
    for row in 1..9
        for col in 1..9
            v = @@m[(row-1)*9+(col-1)]
            if v.length==1
                singles << (row.to_s + col.to_s + v)
            end
        end
    end
    @@s = singles

    #tek olanları gruplardan ayıkla
    for row in 1..9
        for col in 1..9
            if @@m[(row-1)*9+(col-1)].length != 1           #eğer hücrede 1 den fazla sayı varsa
                "123456789".each_char do |x|          # bu sayıların her biri için
                    boxes = ["123","456","789"]
                    row_box = boxes.detect {|v| v.include?(row.to_s)}
                    col_box = boxes.detect {|v| v.include?(col.to_s)}
                    if singles.detect {|v| v =~ (Regexp.new(row.to_s + "[1-9]" + x)) or
                        v =~ Regexp.new("[1-9]" + col.to_s + x)}   # sütunda aynısı varsa
                        @@s = "değer #{x} mat #{singles}"
                        @@m[(row-1)*9+(col-1)].delete! x        # o sayıyı sil
                    elsif singles.detect {|v| v =~ (Regexp.new("[" + row_box + "]" + "[" + col_box + "]" + x))}
                        @@m[(row-1)*9+(col-1)].delete! x        # o sayıyı sil                        
                    else
                        @@m[(row-1)*9+(col-1)] += x
                    end
                end
            end
        end
    end
    
end

get "/" do
    haml :index
end

get "/set/:x/:xx" do
    x = params[:x].to_i
    xx = params[:xx].to_i
    @@m[x-1]=xx.to_s
    check
    redirect("/")
end
  
get "/reset/:x" do
    x = params[:x].to_i
    @@m[x-1]="123456789"
    check
    redirect "/"
end

