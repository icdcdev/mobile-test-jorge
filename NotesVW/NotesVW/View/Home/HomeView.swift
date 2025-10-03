//
//  Home.swift
//  NotesVW
//
//  Created by Devant on 29/09/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var root : BackView
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Notes.entity(), sortDescriptors: [NSSortDescriptor(key: "idServer", ascending: true)], predicate: NSPredicate(format: "pendingSave == %@ && status == 1", NSNumber(value: false)), animation: .spring()) var results: FetchedResults<Notes>
    @FetchRequest(entity: Notes.entity(), sortDescriptors: [NSSortDescriptor(key: "idServer", ascending: true)], predicate: NSPredicate(format: "pendingSave == %@ && status == 1", NSNumber(value: true)), animation: .spring()) var resultsToUpload: FetchedResults<Notes>
    @FetchRequest(entity: Notes.entity(), sortDescriptors: [NSSortDescriptor(key: "idServer", ascending: true)], predicate: NSPredicate(format: "pendingSave == %@ && status == 0", NSNumber(value: false)), animation: .spring()) var resultsToDelete: FetchedResults<Notes>
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            if viewModel.isShowEmpty {
                VStack() {
                    Image("vacio", bundle: nil)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 170, height: 170)
                    
                    Text("Crea tu primera nota")
                        .foregroundColor(Colors.blueTitle)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    
                    Text("Parece vacío por aquí.")
                        .foregroundColor(Colors.textColor)
                        .font(.system(size: 16, weight: .regular, design: .default))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                //Con este codigo la lista se llena desde el viewModel y no de la base
                /*List(viewModel.allNotes.indices, id: \.self) { index in
                 NoteRow(note: viewModel.allNotes[index]){
                 viewModel.showAlertConfirmDelete(note: viewModel.allNotes[index].id, noteIndex: index)
                 }.listRowBackground(Color.clear)
                 .listRowSeparator(.hidden)
                 }.listStyle(.plain)
                 .background(Color.white)*/
                
                List {
                    ForEach(results.indices, id: \.self) { index in
                        NoteRow2(note: results[index]){
                            print("Indice: \(index)")
                            viewModel.showAlertConfirmDelete(noteIndex: index, note: results[index])
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .background(Color.white)
            }
            
            FloatingBtn() {
                root.path.append(Routes.CreateNote)
            }
            
            if viewModel.isLoading {
                GeometryReader { _ in
                    LoaderView()
                }.background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
            AlertView(isPresented: $viewModel.isShowingAlertDelete, message: viewModel.alertMessage){
                viewModel.isShowingAlert = false
                viewModel.deleteNote(context: viewContext)
            }
            
            if viewModel.isConnected {
                Text("Internet.")
                    .foregroundColor(.green)
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .padding([.trailing], 18)
                    .onAppear(){
                        viewModel.uploadNotesPendingDelete(resultsToUpload: resultsToUpload, resultsToDelete: resultsToDelete, context: viewContext)
                    }
            } else {
                Text("No internet.")
                    .foregroundColor(.red)
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .padding([.trailing], 10).onAppear() {
                        viewModel.internetAvailable(isAvailable: false)
                    }
            }
            
        }//End ZStack
        
        //.background(Colors.backgroundView)
        .navigationBarTitle("Mis notas")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                VStack {
                    Image("profile")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            print("Presionando boton de perfil")
                            root.path.append(Routes.Profile)
                        }
                }
            }
        }
        .onAppear {
            // Código ejecutado cuando aparece la vista
            print("Mostrando vista Home")
            viewModel.getPreNotes(context: viewContext, attemps: 0)
            
            //Monitoreo de red iniciado
            viewModel.startMonitoring()
        }
        .onDisappear {
            // Código ejecutado cuando desaparece la vista
            print("Matando vistac Home")
            
            //Monitoreo de red terminado
            //viewModel.stopMonitoring()
        }
        
    }//End Body
    
}
