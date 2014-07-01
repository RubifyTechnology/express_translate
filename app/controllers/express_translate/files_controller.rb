class ExpressTranslate::FilesController < ExpressTranslate::BaseController
  
  # Require or include Libraries
  before_filter :check_login_files
  require 'redis'
  require 'json'
  require 'csv'
  
  # Export to csv file form redis database
  def export
    respond_to do |format|
      format.csv do
        send_data export_csv,
          :type => 'text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=export_v#{Time.now.strftime("%Y_%m_%d_at_%H_%M")}.csv"
      end
    end
  end
  
  # Export form csv file to redis database
  # Upload csv file
  def import
    filename = Rails.root.join('public', "last_import.csv")
    File.open(filename, 'wb') do |file|
      file.write(params[:file_csv].read)
    end
    import_csv(File.open(filename, 'r').path)
    render text: "Uploaded"
  end
  
  def import_yml
    filename = Rails.root.join('public', "last_import.yml")
    File.open(filename, 'wb') do |file|
      file.write(params[:file_yml].read)
    end
    @list_data = []
    lang_id = import_yml_file(File.open(filename, 'r').path)
    add_data_form_list(params["pack"], lang_id)
    render text: "Uploaded"
  end
  
  private
  
  # Check login status when excute with files
  def check_login_files
    redirect_to controller: "account", action: "login" if !check_authentication
  end
  
  # Export files
  def export_csv
    csv_string = CSV.generate do |csv|
      packages = Package.all
      packages.each do |package|
        @package = package
        exp_pack(csv)
      end
      # END PACKAGES
    end
    csv_string
  end
  
  # Import csv file
  def import_csv(path)
    @before_row = []
    @last_package = {}
    @last_header = []
    @action_add = false
    CSV.foreach(path) do |row|
      @action_add = false if row.nil?
      if row.present? and row[0] == "No."
        is_header_row(row)
      end
      add_row(row) if @action_add
      @before_row = row
    end
  end
  
  # Import yml file
  def import_yml_file(path)
    data = YAML.load_file(path)
    data.each do |lang|
      @list_data = to_shallow_hash(lang[1])
      return lang[0]
    end
  end
  
  def add_data_form_list(pack, lang)
    language_detail = LanguageDetail.info({"id"=> lang, "packages"=> pack})
    language_detail.destroy
    @list_data.each do |item|
      language_detail.add({code: item[0], text: item[1]})
    end
  end
  
  def to_shallow_hash(hash)
    hash.inject({}) do |shallow_hash, (key, value)|
      if value.is_a?(Hash)
        to_shallow_hash(value).each do |sub_key, sub_value|
          shallow_hash[[key, sub_key].join(".")] = sub_value
        end
      else
        shallow_hash[key.to_s] = value
      end
      shallow_hash
    end
  end
  
  # Processing
  def exp_pack(csv)
    csv << [@package["id"], @package["text"]]
    @origin_lang = Language.get_origin(@package["id"]) #get Origin language
    
    # add Header for package
    exp_header(csv)
    
    # add all code in languages
    exp_rows(csv)
    
    #End PACKAGE
    csv << ["","-------------------------------"]
    csv << []
  end
  
  # Export row
  def exp_rows(csv)
    all_of_origin = LanguageDetail.info(@origin_lang).all
    all_of_origin.each_with_index do |item, index|
      exp_row(csv, item, index)
    end
  end
  
  # Export header row for file
  def exp_header(csv)
    header = ["No.", "Key", @origin_lang["text"]]
    @package["language"].each do |lang|
      header.push(lang["text"]) if @origin_lang != lang
    end
    csv << header
  end
  
  # Export data with row data
  def exp_row(csv, item, index)
    row = ["#{index+1}", item["code"], item["text"]]
    @package["language"].each do |lang|
      if @origin_lang != lang
        code = LanguageDetail.info(lang).find(item["code"])
        row.push(code.present? ? code["text"] : "")
      end
    end
    csv << row
  end
  
  # Add row when import file
  def add_row(row)
    if row[0].to_i > 0
      index_col = 0
      @last_header.each do |cell_header|
        add_row_detail(row, cell_header, index_col)
        index_col+=1
      end
    end
  end
  
  # Add details of row when import file
  def add_row_detail(row, cell_header, index_col)
    if row[index_col].present?
      lang_id = lang_text_to_id(cell_header)
      LanguageDetail.info({"id" => lang_id, "packages" => @last_package["id"]}).add({code: row[1], text: row[index_col]}) if lang_id.present?
    end
  end
  
  # Set header row for package
  def is_header_row(row)
    packages = Package.all.select{|pack| pack["id"] == @before_row[0]}
    if packages.count > 0
      @action_add = true
      @last_header = row
      @last_package = packages[0]
      clear_lang(@last_package["id"], @last_header)
    end
  end
  
  # Clear old data in language
  def clear_lang(pack_id, row_header)
    row_header.each do |cell_header|
      lang_id = lang_text_to_id(cell_header)
      LanguageDetail.info({"id"=> lang_id, "packages"=> pack_id}).destroy if lang_id.present?
    end
  end
  
  # Detect language id with text language
  def lang_text_to_id(text)
    languages = YAML.load_file("#{ExpressTranslate.root}/config/languages.yml")
    languages.each do |lang|
      return lang[0] if lang[1] == text
    end
    return nil
  end
end