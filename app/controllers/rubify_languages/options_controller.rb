class RubifyLanguages::OptionsController < RubifyLanguages::BaseController

  before_filter :check_login
  
  require 'redis'
  require 'json'
  require 'csv'
  
  include RubifyLanguages
  
  def index
    # RubifyLanguages.reset
#     RubifyLanguages.seeds
    @packages = Package.all
    render :action => :index, layout: 'rubify_languages/translate'
  end
    
  def languages
    @selects = YAML.load_file("#{RubifyLanguages.root}/config/languages.yml")
    origin = Language.get_origin(params[:packages])
    @languages = Package.find(params[:packages])['language']
    @max = origin.nil? ? 1 : LanguageDetail.info(origin).all.count
    @LanguageDetail = LanguageDetail
    @Package = Package
    render :action => :languages, layout: 'rubify_languages/translate'
  end
  
  def language_detail
    @languages = Package.find(params[:package])['language']
    @origin_lang = Language.get_origin(params[:package])
    @LanguageDetail = LanguageDetail
    @lang = {'id'=> params[:id], 'packages'=> params[:package]}
    render :action => :language_detail, layout: 'rubify_languages/translate'
  end
  
  def export
    respond_to do |format|
      format.csv do
        send_data export_csv,
          :type => 'text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=export_v#{Time.now.strftime("%Y_%m_%d_at_%H_%M")}.csv"
      end
    end
  end
  
  def import
    filename = Rails.root.join('public', "last_import.csv")
    File.open(filename, 'wb') do |file|
      file.write(params[:file_csv].read)
    end
    import_csv(File.open(filename, 'r').path)
    render text: "Uploaded"
  end
  
  # AJAX
  def code_add
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    add = @lang_detail.add(params)
    if add['success']
      load_content_code(params)
    else
      render :json => add
    end
  end
  
  def code_update
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    if @lang_detail.find(params[:code]).present?
      @lang_detail.update(params)
    else
      @lang_detail.add(params)
    end
    load_content_code(params)
  end
  
  def code_delete
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    @lang_detail.delete(params[:code])
    load_content_code(params)
  end
  
  
  def language_add
    add = Language.add(params)
    if add['success']
      load_content_language(params)
    else
      render :json => add
    end
  end
  
  def language_update
    update = Language.update_by_id_packages(params[:old_id], params[:packages], params)
    if update['success']
      load_content_language(params)
    else
      render :json => update
    end
  end
  
  def language_delete
    delete = Language.delete_by_id_packages(params[:id], params[:packages])
    if delete['success']
      load_content_language(params)
    else
      render :json => delete
    end
  end
  
  def language_set_origin
    update = Language.set_origin(params[:id], params[:packages])
    if update['success']
      load_content_language(params)
    else
      render :json => update
    end
  end
  
  
  def package_add
    add = Package.add(params)
    if add['success']
      load_content_package(params)
    else
      render :json => add
    end
  end
  
  def package_update
    update = Package.update(params)
    if update['success']
      load_content_package(params)
    else
      render :json => update
    end
  end
  
  def package_delete
    delete = Package.delete(params[:id])
    if delete['success']
      load_content_package(params)
    else
      render :json => delete
    end
  end
  
  private
  
  def load_content_code(params)
    @origin_lang = Language.get_origin(params[:pack])
    @LanguageDetail = LanguageDetail
    @lang = {'id'=> params[:lang], 'packages'=> params[:pack]}
    render :action => :code_update
  end
  
  def load_content_language(params)
    origin = Language.get_origin(params[:packages])
    @languages = Package.find(params[:packages])['language']
    @max = origin.nil? ? 1 : LanguageDetail.info(origin).all.count
    @LanguageDetail = LanguageDetail
    render :action => :language_update
  end
  
  def load_content_package(params)
    @packages = Package.all
    render :action => :package_update
  end
  
  def load_all_yaml(lang="en")
    I18n.backend.send(:translations)[lang.to_sym]
  end      
    
  def check_login
    if !check_authentication
      redirect_to controller: "account", action: "login"
    end
  end
  
  # Export files
  def export_csv
    csv_string = CSV.generate do |csv|
      packages = Package.all
      packages.each do |package|
        csv << [package["id"], package["text"]]
        origin_lang = Language.get_origin(package["id"]) #get Origin language
        
        # add Header for package
        header = ["No.", "Key", origin_lang["text"]]
        package["language"].each do |lang|
          if origin_lang != lang
            header.push(lang["text"])
          end
        end
        csv << header
        # END add Header for package
        
        # add all code in languageg
        all_of_origin = LanguageDetail.info(origin_lang).all
        all_of_origin.each_with_index do |item, index|
          row = ["#{index+1}", item["code"], item["text"]]
          package["language"].each do |lang|
            if origin_lang != lang
              code = LanguageDetail.info(lang).find(item["code"])
              row.push(code.present? ? code["text"] : "")
            end
          end
          csv << row
        end
        # END add all code in languages
        csv << ["","-------------------------------"]
        csv << []
      end
      # END PACKAGES
    end
    csv_string
  end
  
  # Import files
  def import_csv(path)
    before_row = []
    last_package = {}
    last_header = []
    action_add = false
    CSV.foreach(path) do |row|
      if row.nil?
        action_add = false
      elsif row[0] == "No."
        packages = Package.all.select{|pack| pack["id"] == before_row[0]}
        if packages.count > 0
          action_add = true
          last_header = row
          last_package = packages[0]
          clear_lang(last_package["id"], last_header)
        end
      end
      
      if action_add
        if row[0].to_i > 0
          index_col = 0
          last_header.each do |cell_header|
            if row[index_col].present?
              lang_id = lang_text_to_id(cell_header)
              if lang_id.present?
                LanguageDetail.info({"id" => lang_id, "packages" => last_package["id"]}).add({
                  code: row[1],
                  text: row[index_col]
                })
              end
            end
            
            index_col+=1
          end
        end
      end
      
      before_row = row
    end
  end
  
  # Processing
  def clear_lang(pack_id, row_header)
    row_header.each do |cell_header|
      lang_id = lang_text_to_id(cell_header)
      if lang_id.present?
        LanguageDetail.info({"id"=> lang_id, "packages"=> pack_id}).destroy
      end
    end
  end
  
  def lang_text_to_id(text)
    languages = YAML.load_file("#{RubifyLanguages.root}/config/languages.yml")
    languages.each do |lang|
      return lang[0] if lang[1] == text
    end
    return nil
  end
end