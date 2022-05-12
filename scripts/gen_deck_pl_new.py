#!/Users/xindanx./Maltaekni/flashcards/python/bin/python
# -*- coding: utf-8 -*-
import genanki
import random
import csv
import glob
import os
import yaml


## define file path  
project_dir = '.'
output_dir = '.'
audio_dir = './mp3files' 

## always start from cwd
os.chdir(project_dir)
os.getcwd()


## define css style
style = """
      .card {
        font-family: arial;
        text-align: center;
        color: black;
        background-color: white;
      }
      

      .header {
        text-align: left;
        font-size:16px;
      }
      #typeans { width: 150px; }
      center { display:inline; }
      """

## create the randomized deck/model ids
def gen_id():
  ran_id = random.randrange(1 << 30, 1 << 31)
  return ran_id

## create an empty deck
my_deck = genanki.Deck(
  deck_id=gen_id(),
  name = "IceFlash4k_pl_v2")

## generate Anki decks
mp3_path = glob.glob('mp3files/*')
mp3_names = sorted([mp3.split(os.sep)[-1] for mp3 in mp3_path])

## load templates
tmp_dir = glob.glob('templates/anki/pl/*.yml')

## load data and generate cards
tsvfile = "data/list_4k_pl.tsv"
with open(tsvfile, 'r', encoding='utf-8') as file:
  csv_reader = csv.DictReader(file, delimiter = '\t')
  model_field = [{'name': name} for name in csv_reader.fieldnames]
  
  ## holder for models and templates
  mod_tmp = {}
  for file in tmp_dir:
    with open(file, 'r', encoding='utf-8') as f:
      file_name = os.path.basename(file).rsplit('.')[0]
      tmp = yaml.safe_load(f)
      model = genanki.Model(
        gen_id(),
        file_name,
        fields=model_field,
        templates= [tmp],
        css=style)
      my_deck.add_model(model)
      mod_tmp[file_name] = model
  
  ## generate cards
  for row in csv_reader:
    if row['OBEYGJANLEGT'] != 'NA':
      card_model = mod_tmp['obeyg']
    elif row['bin_tag'] == 'so':
      card_model = mod_tmp['so']
    elif row['bin_tag'] == 'afn':
      card_model = mod_tmp['afn']
    elif row['bin_tag'] == 'lo' and row['OBEYGJANLEGT'] =='NA':
      card_model = mod_tmp['lo']
    elif row['bin_tag'] == 'ao':
      card_model = mod_tmp['ao']
    elif row['bin_tag'] in ['kk', 'kvk', 'hk', 'pfn']:
      card_model = mod_tmp['no_pfn']
    elif row['bin_tag'] in ['fn', 'gr', 'rt', 'to']:
      card_model = mod_tmp['fn_gr_to']
    else:
      print(row)
    
    ## format field
    row['pronounce'] = '[sound:{}]'.format(row['pronounce'])

    ## create notes 
    note = genanki.Note(
        model = card_model,
        fields = list(row.values())
        )
    my_deck.add_note(note)

os.chdir(audio_dir)
main_pkg = genanki.Package(my_deck)
main_pkg.media_files = mp3_names
main_pkg.write_to_file(os.path.join(output_dir, "IceFlash4k_pl_v2.apkg"))
os.chdir(project_dir)
print('Finished {}'.format(my_deck.name))
